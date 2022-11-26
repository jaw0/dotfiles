
; setup to do some hilit-ing
; derived from hilit19 shipped w/ emacs

; make nroff look puhr-tee
(hilit-set-mode-patterns
 'nroff-mode
 '(
   ("\\.?[\\\][\\\"].*$" nil comment)
   ("^\\.so .*$"         nil include)
   ("^\\.d.*$"           nil defun)
 ; ("\""                 "\([^\\]\"\|$\)"   string)
   ("\\\\fI"             "\\\\fP"           blue-italic-underline)  ; italic font
   ("\\\\fB"             "\\\\fP"           blue-bold-underline)    ; bold font
   ("\\\\s[-+]?[0-9]"    "\\(\\\\s0\\|$\\)" maroon-underline)       ; change size
   ("\\\\S'[0-9]+'"      "\\(\\\\S'0'\\)"   maroon-italic-underline)       ; change slant
   ("^\\.EQ"             "^\\.EN" seagreen)  ; equations
   ("^\\.TS"             "^\\.TE" navy)      ; tables
   ("^\\.PS"             "^\\.PE" red)       ; PICtures
   ("^\\.[A-Z]."         nil      keyword)   ; misc macros
   ("\\.\\["             "\\.\\]" crossref)  ; refer citations
   )
 nil 'case-insensitive)


;; I am very picky about how my C looks
;; this attrosity comes close to looking reasonable
(let* ((comments     '(("/\\*" "\\*/" comment)))
      (c++-comments '(("//.*$" nil comment)
                      ("^/.*$" nil comment)))
      (strings      '((hilit-string-find ?' violetred-underline)))
      (preprocessor '(("^#[ \t]*\\(undef\\|define\\).*$" "[^\\]$" define)
                      ("^#.*$" nil include)))
      ;; function
      (function      '(("^[a-zA-z].*\\(\\w\\|[$_]\\)+\\s *\\(\\(\\w\\|[$_]\\)+\\s *((\\|(\\)[^)]*)+" nil defun)))

      ;; datatype -- black magic regular expression
      (c-type       '(("[ \n\t({]\\(\\(const\\|register\\|volatile\\|unsigned\\|extern\\|static\\)\\s +\\)*\\(\\(\\w\\|[$_]\\)+_t\\|float\\|double\\|void\\|char\\|short\\|int\\|long\\|FILE\\|\\(\\(struct\\|union\\|enum\\)\\([ \t]+\\(\\w\\|[$_]\\)*\\)\\)\\)\\(\\s +\\*+)?\\|[ \n\t;()]\\)" nil type)))

      ;; key words
      (c-keywords    '(("[^_]\\<\\(return\\|goto\\|if\\|else\\|case\\|default\\|switch\\|break\\|continue\\|while\\|do\\|for\\)\\>[^_]" 1 keyword)))

      (c-decl        '(("^\\(typedef\\|struct\\|union\\|enum\\).*$" nil decl)))
      (c++-type      '(("[^_]\\<\\(class\\|private\\|public\\|protected\\|template\\)\\>[^_]" nil type)))
      (c++-keywords  '(("[^_]\\<\\(cout\\|cin\\|cerr\\|endl\\|new\\|delete\\|private\\|public\\|protected\\)\\>[^_]" nil keyword)))

      ;; misc
      (some-misc     '(("[^_]\\<\\(loop\\|loopp\\|looppp\\|MIN\\|MAX\\|ABS\\)\\>[^_]" 1 navy)))

      ;; some of my std classes
      (jeff-classes  '(("[^_]\\<\\([BFU]image[^ 	(:]*\\|Cmap\\|ColorImage\\|Solid\\|Usolid\\|Fsolid\\|Point\\|BVector\\|Vector\\|CVector\\|Matrix\\|Function\\)\\>[^_]" 1 maroon)))

    (common_order (append
		   comments
		   c++-comments
		   c-type
		   c++-type
		   c-keywords
		   c++-keywords
		   c-decl
		   some-misc
		   jeff-classes
		   preprocessor
		   function
		   )))


  (hilit-set-mode-patterns
   '(c-mode c++-c-mode elec-c-mode)
   (append
    strings c-type c-keywords c-decl some-misc comments preprocessor function
    '(
      ;; function decls are expected to have types on the previous line
      ("^\\(\\w\\|[$_]\\)+\\s *\\(\\(\\w\\|[$_]\\)+\\s *((\\|(\\)[^)]*)+" nil defun)
      ("^[a-zA-Z_]+.*[;{]$" nil ForestGreen)

      )))

  (hilit-set-mode-patterns
   'c++-mode
   (append
    strings
    common_order
    ))

  (hilit-set-mode-patterns
   'lex-mode
   (append
    common_order
    '(
      ("^%[^ \t\n\r]*" nil keyword)
      ("^<[^<> \t\r\n]*>" nil orangered)
      ("{" "}" darkslateblue)
      )))

  (hilit-set-mode-patterns
   'yacc-mode
   (append
    strings
    common_order
    '(
      ("^%[^ \t\n\r]*" nil keyword)
      ("{" "}" darkslateblue))))

  )


(hilit-set-mode-patterns
 '(calendar-mode calendar-load calendar)
 '(("[A-Z][a-z]+ [0-9]+" nil define)    ; month and year
   ("Su Mo Tu We Th Fr Sa" nil label)   ; week days
   ("[0-9]+\\*" nil defun)              ; holidays
   ("[0-9]+\\+" nil comment)            ; diary days
   ))

;; since no calendar-mode-hook gets called (no file gets loaded)
;; it requires some extra work to make my calendar pretty

(add-hook 'today-visible-calendar-hook   'calendar-mark-today)
(add-hook 'today-visible-calendar-hook   'hilit-rehighlight-buffer)
(add-hook 'today-invisible-calendar-hook 'hilit-rehighlight-buffer)
(make-face 'calendar-today-face)
(make-face 'holiday-face)
(set-face-background 'calendar-today-face "green")
(set-face-background 'holiday-face        "white")
(set-face-foreground 'holiday-face        "blue")


;; for jlisp
(hilit-set-mode-patterns
 'jeff-lisp-mode
 '(
   (";.*" nil comment)
   ("#|" "|#" comment)

;   ("[^ ] *^" nil white)
   (hilit-string-find ?\\ violetred-underline)
   ;;   ("^\\s *def\\(un\\|mac\\)[ \t\n]" "\\()\\|nil\\)" defun)
   ("^\\s *\\((\\|{\\)def\\(un\\|mac\\)[ \t\n]" nil defun)
   ("^\\s *\\((\\|{\\)def\\(ine-with\\|class\\|struct\\)[ \t\n]" nil define)
   ("^\\s *\\((\\|{\\)def\\(ine\\|var\\)" nil define)
   ("\\(#t\\|#f\\)" nil maroon)
   ("^\\s *(\\(provide\\|require\\|\\(auto\\)?load\\).*$" nil include)
   ("\\s *\\&\\(rest\\|optional\\)\\s *" nil keyword)
   ("(\\(let\\*?\\|cond\\|case\\|if\\|or\\|and\\|map\\(car\\|concat\\)\\|prog[n1*]?\\|while\\|lambda\\|macro\\|set\\([qf!]\\|-car\\|-cdr\\|s!\\)?\\|unwind-protect\\|catch\\|throw\\|error\\)[ \t\n]" 1 keyword)
   ("(\\(car\\|cdr\\|cons\\|nconc\\|list\\|vector\\|nth\\|eq\\|equal\\|eqv\\|eval\\|funcall\\|apply\\)[ \t\n]" 1 keyword)
   ))


;; an attempt at html...
(hilit-set-mode-patterns
 'html-mode
 '(
   ("<HR>"         nil             red-underline)      ;horiz line
   ("<!"           ">"             comment)            ;comments
   ("<IMG"         ">"             maroon-underline)   ;inline images
   ("<A"           ">"             seagreen-underline) ;link anchors
   ("</A>"         nil             seagreen-underline) ;link anchor
   ("<"            ">"             keyword)            ;all other tags
   ("<B>"          "</B>"          orangered-bold)     ;misc format directives
   ("<I>"          "</I>"          orangered-italic)
   ("<STRONG>"     "</STRONG>"     orangered-bold)
   ("<EM>"         "</EM>"         orangered-italic)
   ("<PRE>"        "</PRE>"        seagreen)
   ("<CODE>"       "</CODE>"       seagreen)
   ("<DFN>"        "</DFN>"        seagreen-bold)
   ("<CITE>"       "</CITE>"       seagreen-italic)
   ("<KBD>"        "</KBD>"        seagreen)
   ("<SAMP>"       "</SAMP>"       seagreen)
   ("<VAR>"        "</VAR>"        seagreen-bold)
   ("<TT>"         "</TT>"         seagreen)
   ("<BLOCKQUOTE>" "</BLOCKQUOTE>" seagreen-italic)
   ("<A"           "</A>"          blue-bold)          ;link text
   ("<H.>"         "</H.>"         red-bold)           ;headers
   ("<TITLE>"      "</TITLE>"      red-bold)))

;; i96 asm
(hilit-set-mode-patterns
 'i96-mode
 '(
   ("\\<[^ 	\n]*\\>:" nil seagreen-bold)
   (";.*$" nil comment)
   ("[^_]\\<\\(near\\|skip\\|even\\|org\\|ascii\\|asciz\\|byte\\|word\\|long\\|align\\|proc\\|globl\\|abort\\|enum\\|hex\\|bin\||s19\\|symtab\\|symlocal\\)\\>[^_]" 1 keyword)
   ("[^_]\\<\\(equ\\|db\\|dfb\\|dfs\\|org\\|dw\\|dfw\\)\\>[^_]" 1 keyword)
   (hilit-string-find ?' violetred-underline)
   ("^#[ \t]*\\(undef\\|define\\).*$" "[^\\]$" define)
   ("^#.*$" nil include)))
