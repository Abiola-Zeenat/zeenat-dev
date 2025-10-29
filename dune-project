(lang dune 3.20)
(name zeenat-dev)
(version dev)
(generate_opam_files)

(source (github Abiola-Zeenat/zeenat-dev))
(license MIT)
(authors "Abiola Zeenat Abdulsalam")
(maintainers "Abiola Zeenat Abdulsalam>")

(package
 (name zeenat-dev)
 (synopsis "My website using YOCaml")
 (description
   "My personal website using YOCaml for
   fun and better understanding of YOCaml")
 (allow_empty)
 (depends
  (ocaml (>= 5.3.0))

  (yocaml (>= 2.5.0))
  (yocaml_unix (>= 2.5.0))
  (yocaml_yaml (>= 2.5.0))
  (yocaml_markdown (>= 2.5.0))
  (yocaml_jingoo (>= 2.5.0))

  ;; Dev setup
  (utop :with-dev-setup)
  (ocamlformat :with-dev-setup)
  (ocp-indent :with-dev-setup)
  (merlin :with-dev-setup)
  (ocaml-lsp-server :with-dev-setup)
 )
)