;; Copyright (c) 2007 by Jeff Weisberg
;; Author: Jeff Weisberg <jaw @ tcp4me.com>
;; Created: 2007-Feb-22 11:37 (EST)
;; Function: for editing mason code
;;
;; $Id: jaw-mason.el,v 1.3 2009/02/21 23:17:41 jaw Exp $

(make-face 'mason-code-face) (set-face-background 'mason-code-face "#ccccff")
(make-face 'mason-comp-face) (set-face-background 'mason-comp-face "#ccffcc")
(make-face 'mason-attr-face) (set-face-background 'mason-attr-face "#ffcc88")

(defvar mason-font-lock-keywords
  (list
   '( "^</?%.*>"   . font-lock-keyword-face)
   '( "^%#.*$"     . font-lock-comment-face)
   '( "<!--.*?-->" . font-lock-comment-face)
   '( "^%.*$"      . 'mason-code-face)
   '( "<%.*?%>"    . 'mason-code-face)
   '( "<&.*?&>"    . 'mason-comp-face)))


