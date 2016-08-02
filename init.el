;; packages
(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("marmalade" . "https://marmalade-repo.org/packages")
	("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(defun ensure-installed (package)
  (if (not (package-installed-p package))
      (package-install package)))

(let ((package-list '(company racket-mode helm flycheck rtags
			      material-theme better-defaults
                              elpy annotate irony company-irony
                              flycheck-irony)))
  (mapc (lambda (x) (ensure-installed x)) package-list))

;; Colors
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'material t)

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

;; Real-time linting with flycheck
(add-hook 'after-init-hook 'global-flycheck-mode)

;; Emacs Lisp Python Environment -- indent, syntax, completion, repl, etc.
;; requires you to 'pip install flake8 jedi ipython'
(elpy-enable)
(elpy-use-ipython)
(when (require 'flycheck nil t) ;; Replace flymake with flycheck
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Enable rtags (install rtags on your own and run rdm)
(require 'rtags)
(rtags-enable-standard-keybindings)

;; Irony stuff
(add-hook 'c-mode-common-hook 'irony-mode)
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

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
