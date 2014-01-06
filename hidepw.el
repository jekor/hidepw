;;; hidepw.el --- Minor mode to hide passwords

;; Copyright (C) 2014 Chris Forno

;; Author: Chris Forno <jekor@jekor.com>
;; Package-Version: 0.1.0
;; Keywords: hide, hidden, password

;;; Commentary:

;; When enabled, any passwords will appear as ******, but you'll
;; still be able to copy the password to the clipboard.
;;
;; This mode turns on font-lock-mode (and won't turn it off when you
;; turn off this mode).
;;
;; If you manage passwords in GPG files, you can enable hidepw-mode
;; automatically with:
;;
;; (add-to-list 'auto-mode-alist
;;              '("\\.gpg\\'" . (lambda () (hidepw-mode))))

;;; Code:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; User Variables:

(defgroup hidepw nil "Settings for hiding passwords")

(defcustom hidepw-pattern "|\\(.*\\)|"
  "Pattern for identifying a password (must contain 1 capturing group)"
  :type 'regexp
  :group 'hidepw)

(defcustom hidepw-mask "******"
  "String to obscure passwords with"
  :type 'string
  :group 'hidepw)

(defun hidepw-font-lock-keywords ()
  `((,hidepw-pattern 1 (hidepw-render))))

(defun hidepw-render ()
  "Render a password (hidden)."
  `(face font-lock-doc-face
         display ,hidepw-mask))

(defun hidepw-turn-on ()
  "Turn on hidepw-mode."
  (let ((props (make-local-variable 'font-lock-extra-managed-props)))
    (add-to-list props 'display))
  (font-lock-add-keywords nil (hidepw-font-lock-keywords)))

(defun hidepw-turn-off ()
  "Turn off hidepw-mode."
  (font-lock-remove-keywords nil (hidepw-font-lock-keywords)))

;;;###autoload
(define-minor-mode
  hidepw-mode
  "Hide passwords."
  :lighter " HidePW"
  (progn
    (if hidepw-mode
        (hidepw-turn-on)
      (hidepw-turn-off))
    (font-lock-mode 1)))

(provide 'hidepw)

(run-hooks 'hidepw-load-hook)

;;; hidepw.el ends here
