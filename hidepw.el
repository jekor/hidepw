;;; hidepw.el --- Minor mode to hide passwords

;; Author: Chris Forno <jekor@jekor.com>
;; Package-Version: 0.1.0
;; Keywords: hide, hidden, password

;; Copyright (C) 2014, Chris Forno
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;;     * Redistributions of source code must retain the above copyright
;;       notice, this list of conditions and the following disclaimer.
;;     * Redistributions in binary form must reproduce the above copyright
;;       notice, this list of conditions and the following disclaimer in the
;;       documentation and/or other materials provided with the distribution.
;;     * Neither the name of Chris Forno nor the names of his contributors may
;;       be used to endorse or promote products derived from this software
;;       without specific prior written permission.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL CHRIS FORNO BE LIABLE FOR ANY
;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
;; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

;;; Commentary:

;; This is a minor mode for hiding passwords. It's useful if you
;; manage your passwords in text files (perhaps automatically
;; encrypted and decrypted by EasyPG) and want to prevent shoulder
;; surfing.
;;
;; When enabled, any passwords will appear as ******, but you'll still
;; be able to copy the password to the clipboard.
;;
;; By default, passwords are marked by delimiting them with pipes (|).
;; For example:
;;
;; root: |supersecret|
;;
;; will display as
;;
;; root: |******|
;;
;; You can customize hidepw-pattern to match against arbitrary regular
;; expressions. Just make sure to include one capturing group (\(\))
;; since the group marks the actual password. You can also customize
;; the mask (******) that obscures the password.
;;
;; You can enable hidepw-mode automatically on .gpg files with:
;;
;; (add-to-list 'auto-mode-alist
;;              '("\\.gpg\\'" . (lambda () (hidepw-mode))))
;;
;; Notes:
;;
;; You won't be able to move the cursor within the password (it will
;; behave like a single character), but deleting the delimiter from
;; either side will reveal the password and make it editable. Just add
;; the delimiter back to hide it again.
;;
;; This mode turns on font-lock-mode (and won't turn it off when you
;; turn off this mode).

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
