;; packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(defun ensure-installed (package)
  (if (not (package-installed-p package))
      (package-install package)))

(let ((package-list '(company racket-mode helm)))
  (mapc (lambda (x) (ensure-installed x)) package-list))

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
(menu-bar-mode 0)
(tool-bar-mode 0)

;; Auto-complete with company mode (requires company-mode package)
(company-mode t)
(add-hook 'after-init-hook 'global-company-mode)


;; CC-mode style preferences + automatic indentation. (electric-mode terrible in Python)
(defun my-c-mode-hook ()
  (c-set-style "k&r")
  (setq c-basic-offset 4)
  (electric-indent-mode 1)
  (local-set-key (kbd "C-o") 'ff-find-related-file))
(add-hook 'c-mode-common-hook 'my-c-mode-hook)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; Org-mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "~/org/agenda.org"))

;; helm mode stuff
(require 'helm)
(define-key global-map (kbd "M-x") 'helm-M-x)

;; Racket mode
(if (string-match "apple" (emacs-version))
    ;; Racket on OS X doesn't go in PATH, need to set these manually
    (progn
      (setq racket-racket-program "/Applications/Racket v6.1.1/bin/racket")
      (setq racket-raco-program "/Applications/Racket v6.1.1/bin/raco")))
(add-hook 'racket-mode-hook
	  (lambda ()
	    (define-key racket-mode-map (kbd "C-c r") 'racket-run)))
