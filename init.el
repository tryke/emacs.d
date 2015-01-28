;; Colors
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)

;; ido-mode is great for autocompleting stuff in the minibuffer.
(ido-mode 1)
(setq ido-enable-flex-matching t)

;; Move those pesky backup files so they stop cluttering up my filesystem
(setq backup-directory-alist '(("." . "~/.emacs-saves")))
(setq backup-by-copying t)

;; Get rid of that nagging startup screen
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)

;; CC-mode style preferences + automatic indentation. (electric-mode terrible in Python)
(defun my-c-mode-hook ()
  (c-set-style "k&r")
  (setq c-basic-offset 4)
  (electric-indent-mode 1)
  (local-set-key (kbd "C-o") 'ff-find-related-file))
(add-hook 'c-mode-common-hook 'my-c-mode-hook)

;; Org-mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "~/org/agenda.org"))

