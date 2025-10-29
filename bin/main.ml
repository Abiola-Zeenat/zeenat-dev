open Yocaml

let www = Path.rel [ "_www" ]
let assets = Path.rel [ "assets" ]
let content = Path.rel [ "content" ]

let images = Path.(assets / "images")
let css = Path.(assets / "css")
let pages = Path.(content / "pages")
let templates = Path.(assets / "templates")

let with_ext exts file =
  List.exists  (fun ext -> Path.has_extension ext file) exts
let track_binary = 
  Sys.executable_name
  |> Yocaml.Path.from_string
  |> Pipeline.track_file

let copy_images =
  let images_path = Path.(www / "images")
  and where = with_ext [ "svg"; "png"; "jpg"; "gif" ] in
  Batch.iter_files 
    ~where images 
    (Action.copy_file ~into:images_path)

let create_css =
  let css_path = Path.(www / "style.css") in
  Action.Static.write_file css_path
    Task.(
      track_binary
      >>> Pipeline.pipe_files ~separator:"\n"
            Path.[ 
              css / "style.css"
            ; css / "reset.css" ])  

let create_page source =
  let page_path =
    source 
    |> Path.move ~into:www 
    |> Path.change_extension "html"
  in
  let pipeline =
    let open Task in
    let+ () = track_binary
    and+ apply_templates = 
      Yocaml_jingoo.read_templates 
        Path.[ templates / "layout.html" ]
    and+ metadata, content =
      Yocaml_yaml.Pipeline.read_file_with_metadata
        (module Archetype.Page)
        source
    in
    content 
    |> Yocaml_markdown.from_string_to_html
    |> apply_templates (module Archetype.Page) ~metadata
  in
  Action.Static.write_file page_path pipeline

let create_pages =
  let where = with_ext [ "md"; "markdown"; "mdown" ] in
  Batch.iter_files ~where pages create_page

let program () =
  let open Eff in
  let cache = Path.(www / ".cache") in
  Action.with_cache cache 
    (copy_images >=> create_css >=> create_pages) 
  
let () = Yocaml_unix.run program