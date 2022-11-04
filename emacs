;; .emcas file content, AA, 2022
;; First enable package management
(require 'package)
(setq package-archives
      '(("elpa" . "https://elpa.gnu.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")
	("melpa" . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("melpa-stable" . 10)
	("elpa" . 5)
	("melpa" . 0)))
(package-initialize)
;; The next line may need commenting if you see a
;; package relatedprocess existing already
(package-refresh-contents)
;; In some systems the packages will need to be installed
;; manually (use-package, which-key, ace-window, workgroup)
;; as the install-package does not seem to work
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; Display Key hints 
(unless (package-installed-p 'which-key)
  (package-install 'which-key))
(require 'which-key)
(use-package which-key
	 :init (which-key-mode)
	 :diminish which-key-mode
	 :config
	 (setq which-key-idle-delay 1))

;; Some packages and the misterioso theme by default
(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
'(ansi-color-faces-vector
  [default default default italic underline success warning error])
'(blink-cursor-mode nil)
'(cua-mode t nil (cua-base))
'(custom-enabled-themes (quote (misterioso)))
'(package-selected-packages
   (quote
   (queue ace-window dash org org-auto-expand org-autolist org-beautify-theme org-board org-bookmark-heading org-brain org-bullets org-cliplink org-dashboard org-doing org-download org-if org-journal org-journal-list org-kanban org-make-toc org-mime org-mind-map org-notebook org-noter org-outline-numbering org-pomodoro org-radiobutton org-recent-headings org-ref-prettify org-review org-scrum org-sidebar org-starter org-sticky-header org-superstar org-table-color org-table-comment org-table-sticky-header org-tag-beautify org-tracktable org-treeusage org-wc orglue origami origami-predef workgroups which-key)))
'(save-place t)
'(size-indication-mode t)
'(tool-bar-mode nil))
(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
)


;; General settings for eamcs
(setq gc-cons-threshold 50000000)
(setq gnutls-min-prime-bits 4096)
(setq visible-bell t)
(setq inhibit-startup-message t)
(setq-default fill-column 80)

(global-font-lock-mode 1)



;; Define settings for GUI window system
(when window-system (set-frame-size (selected-frame) 134 38))
(when (window-system)
  (tool-bar-mode 0)
  (when (fboundp 'horizontal-scroll-bar-mode)
     (horizontal-scroll-bar-mode -1))
  (scroll-bar-mode -1))

;; Enable better undo -disabled for the moment
;;(use-package undo-tree
;; :ensure t
;; :diminish undo-tree-mode
;; :init
;; (global-undo-tree-mode 1)
;; :config
;; (defalias 'redo 'undo-tree-redo)
;; :bind (("C-z" . undo)
;;  ("C-S-z" . redo)))

;; Moving windows
(use-package ace-window
   :ensure t
   :init
      (setq aw-keys '(?a ?s ?d ?f ?j ?k ?l ?o))
      (global-set-key (kbd "C-x o") 'ace-window)
   :diminish ace-window-mode)

;; Org mode related settings
(use-package org
 :ensure t ; But it comes with Emacs now!?
 :init
 (setq org-use-speed-commands t
       org-return-follows-link t
       ;;    org-hide-emphasis-markers t
       ;;    org-completion-use-ido t
       org-outline-path-complete-in-steps nil
       org-src-fontify-natively t   ;; Pretty code blocks
       org-src-tab-acts-natively t
       org-confirm-babel-evaluate nil
       org-todo-keywords '((sequence "TODO(t)" "DOING(g)" "|" "DONE(d)")
			   (sequence "|" "CANCELED(c)")))
 (setq org-pretty-entities t
       org-ellipsis " ▹ " ;; folding symbol
       org-hide-emphasis-markers t
       org-fontify-whole-heading-line t
       org-fontify-done-headline t
       org-fontify-quote-and-verse-blocks t
       ;; show actually italicized text instead of /italicized text/
       org-log-done t
       org-log-into-drawer t
       org-return-follows-link t
       org-refile-use-outline-path 'file
       org-outline-path-complete-in-steps nil
       )
 (add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))
 (add-to-list 'auto-mode-alist '(".*/[0-9]*$" . org-mode))  ;; Journal entries
;; (add-hook 'org-mode-hook 'yas-minor-mode-on)
 :bind (("C-c l" . org-store-link)
	("C-c c" . org-capture)
	("C-M-|" . indent-rigidly))
 :config
 (define-key org-mode-map (kbd "M-C-n") 'org-end-of-item-list)
 (define-key org-mode-map (kbd "M-C-p") 'org-beginning-of-item-list)
 (define-key org-mode-map (kbd "M-C-u") 'outline-up-heading)
 (define-key org-mode-map (kbd "M-C-w") 'org-table-copy-region)
 (define-key org-mode-map (kbd "M-C-y") 'org-table-paste-rectangle)
 
 (define-key org-mode-map [remap org-return] (lambda () (interactive)
					       (if (org-in-src-block-p)
						   (org-return)
						 (org-return-indent)
						 ))))

(setq default-major-mode 'org-mode)
(add-hook 'org-mode-hook 'auto-fill-mode)
(add-hook 'org-mode-hook 'org-indent-mode)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; Path to latex, ensure latexmk is installed!
(setq org-latex-pdf-process (list "/usr/bin/latexmk -shell-escape -bibtex -f -pdf %f"))

;; Store windows lay out in workgroups
;; If you see the workgroups file missing you will need to
;; create a workgroup (M-x wg-create-workgroup), set the windows
;; as you like them, update the workgroup settings (M-x
;; wg-update-workgroup) and saving the workgroup to the path
;; below (M-x wg-save)
(use-package workgroups
	     :ensure t
	     :diminish workgroups-mode
	     :config
	     (setq wg-prefix-key (kbd "C-c a"))
	     (workgroups-mode 1)
	     (wg-load "~/.emacs.d/workgroups")
	     )

;; Default to UTF8
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
