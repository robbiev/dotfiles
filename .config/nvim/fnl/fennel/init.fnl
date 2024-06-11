(module init
  {require {a aniseed.core
            reload reload
            other other}})

;; When loading modules, load .fnl files and compile them on the fly
;; Passing :compiler-env _G due to globals in aniseed.macros, see
;; https://fennel-lang.org/reference#macro-gotchas
(when false
  (let [fennel (require "fennel")]
    (table.insert (or package.loaders package.searchers) 1 (fennel.make-searcher {:compiler-env _G}))))

;; Force loading a module, bypassing the lua require cache
(when false
  (reload.fennel-reload-form "other"))

(other.hello)
