(module reload
  {require {a aniseed.core}})

;; Based on https://technomancy.us/189
;;
;; 1. Trigger recompile:
;; :lua require('aniseed.env').init()
;;
;; 2. (fennel-reload-form "my-module")
;;
(defn fennel-reload-form [name]
  "Reload the given module"
  (let [old (require name)
        _ (tset package.loaded name nil)
        new (require name)]
    ;; if the module isnt a table then we can't make
    ;; changes which affect already-loaded code, but if
    ;; it is then we should splice new values into the
    ;; existing table and remove values that are gone.
    (when (= (type new) :table)
      (each [k v (pairs new)]
        (tset old k v))
      (each [k (pairs old)]
        (when (not (. new k))
          (tset old k nil)))
      (tset package.loaded name old))))
