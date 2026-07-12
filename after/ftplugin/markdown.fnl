(import-macros {: set-local!} :macros)

(set-local! wrap)
(set-local! spell)

(local mini-ai (require :mini.ai))

(set vim.b.miniai_config
     {:custom_textobjects {:S ["```().-()```"]
                           :* (mini-ai.gen_spec.pair "*" "*" {:type :greedy})
                           :_ (mini-ai.gen_spec.pair "_" "_" {:type :greedy})}})

(local mini-surround (require :mini.surround))

(set vim.b.minisurround_config
     {:custom_surroundings {;; Bold
                            :B {:input ["%*%*().-()%*%*"]
                                :output {:left "**" :right "**"}}
                            ;; Link
                            :L {:input ["%[().-()%]%(.-%)"]
                                :output (fn []
                                          (let [link (mini-surround.user_input "Link: ")]
                                            {:left "["
                                             :right (.. "](" link ")")}))}}})
