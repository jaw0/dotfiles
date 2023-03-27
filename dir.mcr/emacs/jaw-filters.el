

;; define a nice set of text filters

(defun uuencode ()
  "uuencode the marked text"
  (interactive)
  (shell-command-on-region (mark) (point) "uuencode NONAME" t t))

(defun insert-fortune ()
  "insert an entry from the fortune file"
  (interactive)
  (shell-command-on-region (point) (point) "fortune" t))

(defun ruby-to-json ()
  "convert ruby syntax data to json"
  (interactive)
  (shell-command-on-region (mark) (point)
                           "ruby -r json -e 'print JSON.pretty_generate(eval STDIN.read)'" t t))

