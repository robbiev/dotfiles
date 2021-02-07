(require-macros "aniseed.macros")
(module other
  {require {a aniseed.core}})

(defn hello [] (a.println "hello fennel"))
