(use-package elec-pair :straight (:type built-in)
  :demand
  :custom
  (electric-pair-pairs '((?\" . ?\") (?\{ . ?\})))
  :config
  (electric-pair-mode 1))

(use-package evil
  :demand
  :custom
  (evil-respect-visual-line-mode t)
  (evil-shift-width 4)
  (evil-undo-system 'undo-tree)
  (evil-split-window-below t)
  (evil-vsplit-window-right t)
  (evil-want-C-i-jump nil)
  (evil-want-C-u-scroll nil)
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-auto-indent nil)
  (evil-echo-state nil)
  :config
  (evil-mode 1)
  :general
  ('insert
   "C-g" #'evil-normal-state)
  :gfhook
  ; Issue: https://github.com/noctuid/evil-guide#why-dont-keys-defined-with-evil-define-key-work-immediately
  ('after-init-hook #'(lambda (&rest _)
       (when-let ((messages-buffer (get-buffer "*Messages*")))
         (with-current-buffer messages-buffer
           (evil-normalize-keymaps)))) nil nil t))

(use-package evil-collection
  :demand
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  ;; (evil-collection-outline-bind-tab-p nil)
  :config
  (evil-collection-init))

(use-package evil-org
  :demand
  :after (evil evil-collection org)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-nerd-commenter
  :after evil
  :preface
  (defun counsel-imenu-comments ()
	(interactive)
	(let* ((imenu-create-index-function 'evilnc-imenu-create-index-function))
	  (unless (featurep 'counsel) (require 'counsel))
	  (counsel-imenu)))
  :general
  ('motion
   "M-;" 'evilnc-comment-or-uncomment-lines))

(use-package evil-surround
  :after evil
  :demand
  :config
  (global-evil-surround-mode 1)
)

(use-package evil-goggles
  :demand
  :after evil
  :custom
  (evil-goggles-duration 0.3)
  (evil-goggles-async-duration 0.9)
  :config
  (custom-set-faces
   '(evil-goggles-default-face ((t (:inherit region :background "gray60")))))
  (evil-goggles-mode 1))

(use-package vi-tilde-fringe
  :hook (prog-mode . vi-tilde-fringe-mode)
; Disable for some modes
  ((treemacs-mode
    dashboard-mode) . (lambda () (vi-tilde-fringe-mode 0)))
  :config ())  ; Show message if verbose is activated

;; (setq-default fill-column 120)
;; (setq fill-column 120)

(use-package visual-line :straight (:type built-in)
  :hook ((text-mode outline-mode) . visual-line-mode)
  :custom
  (visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
  :config ())  ; Show message if verbose is activated

(use-package isearch :straight (:type built-in)
  :demand
  :general
  (isearch-mode-map
   "M-e" 'consult-isearch                 ;; orig. isearch-edit-string
   "M-s e" 'consult-isearch               ;; orig. isearch-edit-string
   "M-s l" 'consult-line                  ;; needed by consult-line to detect isearch
   "M-s L" 'consult-line-multi)           ;; needed by consult-line to detect isearch
  )

(use-package undo-tree
  :demand
  :config (global-undo-tree-mode))

(use-package yasnippet
  ;; :ghook ('(conf-mode-hook prog-mode-hook text-mode-hook) #'yas-minor-mode)
  :demand
  :config 
  (yas-global-mode 1)
)  ; Show message if verbose is activated

(use-package yasnippet-snippets
  :after yasnippet)

(use-package doom-snippets
  :straight (doom-snippets :type git :host github :repo "hlissner/doom-snippets" :files ("*.el" "*"))
  :after yasnippet)

(use-package paren :straight (:type built-in)
  :demand
  :custom
  (show-paren-style 'parenthesis)
  (show-paren-delay 0.125)
  (blink-matching-paren t)
  (blink-matching-delay 1)
  :config
  (show-paren-mode 1))

(use-package corfu
  :demand
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0)
  (corfu-auto-prefix 2)
  :config
  (corfu-global-mode 1)
  :general
  (corfu-map
   "M-j" #'corfu-next
   "M-k" #'corfu-previous))

(use-package cape
  :after corfu
  :demand
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-abbrev)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-dict)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-ispell)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-line)
  (add-to-list 'completion-at-point-functions #'cape-rfc1345)
  (add-to-list 'completion-at-point-functions #'cape-sgml)
  (add-to-list 'completion-at-point-functions #'cape-symbol)
  (add-to-list 'completion-at-point-functions #'cape-tex)
  :general 
  (leader-def
   "c p" #'completion-at-point ;; capf
   "c a" #'cape-abbrev
   "c d" #'cape-dabbrev        ;; or dabbrev-completion
   "c w" #'cape-dict
   "c f" #'cape-file
   "c i" #'cape-ispell
   "c k" #'cape-keyword
   "c l" #'cape-line
   "c r" #'cape-rfc1345
   "c &" #'cape-sgml
   "c s" #'cape-symbol
   "c t" #'complete-tag        ;; etags
   "c _" #'cape-tex
   "c ^" #'cape-tex
  ))

(use-package dabbrev :straight (:type built-in)
  :general
  (general-swap-key nil 'global
    "M-/" "C-M-/"))

(use-package rainbow-mode
  :preface
  (defun rainbow-turn-off-hexadecimal ()
    "Turn off hexadecimal colours in rainbow-mode."
    (interactive)
    (font-lock-remove-keywords
     nil
     `(,@rainbow-hexadecimal-colors-font-lock-keywords))
    (font-lock-fontify-buffer))

  (defun rainbow-turn-off-words ()
    "Turn off word colours in rainbow-mode."
    (interactive)
    (font-lock-remove-keywords
     nil
     `(,@rainbow-x-colors-font-lock-keywords))
    (font-lock-fontify-buffer))
  :hook ((prog-mode text-mode) . rainbow-mode)
  :config ())  ; Show message if verbose is activated

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :config ())  ; Show message if verbose is activated

(use-package good-scroll
:demand
:preface
:custom
(good-scroll-step 50)
:config
(good-scroll-mode 1)
:general
("<wheel-up>"   'good-scroll-up
 "<wheel-down>" 'good-scroll-down
 ;; [remap scroll-up-command]          'good-scroll-up
 ;; [remap scroll-down-command]          'good-scroll-down
 [next] #'good-scroll-up-full-screen
 [prior] #'good-scroll-down-full-screen))

(use-package highlight-parentheses
  :hook ((prog-mode text-mode) . highlight-parentheses-mode)
  :config ())  ; Show message if verbose is activated

(use-package highlight-numbers
  :hook ((prog-mode text-mode) . highlight-numbers-mode)
  :config ())  ; Show message if verbose is activated
;; '(highlight-numbers-number ((t (:foreground "#f0ad6d"))))

(use-package beacon
  :demand
  :custom
  (beacon-size 40)
  (beacon-color 0.6)
  ;; (beacon-blink-duration)
  ;; (beacon-blink-delay)
  (beacon-blink-when-window-scrolls t)
  (beacon-blink-when-window-changes t)
  (beacon-blink-when-focused t)
  (beacon-blink-when-point-moves t)
  ;; (beacon-dont-blink-major-modes)
  ;; (beacon-dont-blink-predicates)
  ;; (beacon-dont-blink-commands)
  ;; (beacon-push-mark)
  :config
  ;; Disable it only in specific buffers
  ;; (setq-local beacon-mode nil).
  (beacon-mode 1))

(use-package treemacs
  :hook
  ((gdscript-mode) . (lambda () (save-selected-window (treemacs-select-window))))
  :custom
  ;; (treemacs-display-in-side-window          nil)
  ;; (treemacs-expand-after-init               t)
  ;; (treemacs-position                        'left)
  ;; (treemacs-silent-filewatch                nil)
  ;; (treemacs-silent-refresh                  nil)
  ;; (treemacs-sorting                         'alphabetic-asc)
  ;; (treemacs-user-mode-line-format           "none")
  (treemacs-width                           28)
  (treemacs-follow-after-init t)
  (treemacs-no-delete-other-windows nil)
  :config
  (add-hook
   'gdscript-mode-hook
   (lambda () (run-with-timer 10.0 nil #'treemacs-select-window)))
  (treemacs-follow-mode t)
  ;; (treemacs-tag-follow-mode t)
  ;; (treemacs-display-current-project-exclusively)
  (treemacs-fringe-indicator-mode 'always)
  (treemacs-git-mode 'simple)
  (treemacs-filewatch-mode t)
  (treemacs-indent-guide-mode t)
  (treemacs-project-follow-mode t)
  (treemacs-hide-gitignored-files-mode nil)

  ;; (pcase (cons (not (null (executable-find "git")))
  ;;              (not (null treemacs-python-executable)))
  ;;   (`(t . t)
  ;;    (treemacs-git-mode 'deferred))
  ;;   (`(t . _)
  ;;    (treemacs-git-mode 'simple)))
  :general
  ("M-0"   #'treemacs-select-window)
  (leader-def
	"0 0" #'treemacs
	"0 b" #'treemacs-bookmark
	"0 t" #'treemacs-find-tag
	"0 f" #'treemacs-find-file
	"0 d" #'treemacs-delete-other-windows
	)
)

(use-package treemacs-evil
  :after (treemacs evil)
  :demand)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :demand)

(use-package treemacs-magit
  :after (treemacs magit)
  :demand)

(use-package vimish-fold
  :after evil
  :demand
  :config
  (vimish-fold-global-mode 1))

(use-package evil-vimish-fold
  :after (evil vimish-fold)
  :demand
  :hook ((prog-mode conf-mode text-mode) . evil-vimish-fold-mode))

(use-package files :straight (:type built-in)
  :demand
  :preface
  (defun +/save-buffers-kill-emacs (&optional arg)
	"Offer to save each buffer(once only, no modified buffers exist asking), then kill this Emacs process.
With prefix ARG, silently save all file-visiting buffers, then kill."
	(interactive "P")
	(save-some-buffers arg t)
	(and (or (not (fboundp 'process-list))
		 ;; process-list is not defined on MSDOS.
		 (let ((processes (process-list))
		       active)
		   (while processes
		     (and (memq (process-status (car processes)) '(run stop open listen))
			  (process-query-on-exit-flag (car processes))
			  (setq active t))
		     (setq processes (cdr processes)))
		   (or (not active)
		       (progn (list-processes t)
			      (yes-or-no-p "Active processes exist; kill them and exit anyway? ")))))
	     ;; Query the user for other things, perhaps.
	     (run-hook-with-args-until-failure 'kill-emacs-query-functions)
	     (or (null confirm-kill-emacs)
		 (funcall confirm-kill-emacs "Really exit Emacs? "))
	     (kill-emacs)))
  :custom
  (vc-handled-backends nil)
  (vc-follow-symlinks t)
  (vc-git-print-log-follow nil)
  (find-file-visit-truename t)
  :config
  (fset 'save-buffers-kill-emacs '+/save-buffers-kill-emacs)
  :general
  (leader-def
    "f" '(:ignore t :which-key "file")
    "f f" #'(find-file :wk "find")
    "f c" #'((lambda () (interactive) (find-file "~/.config/emacs/TANGLE.org")) :wk "config")
    "b k" #'(kill-current-buffer :wk "kill current buffer")
    "b K" #'(kill-buffer :wk "kill buffer")
    "b n" #'(next-buffer :wk "next buffer")
    "b p" #'(previous-buffer :wk "previous buffer")
))

(use-package autorevert :straight (:type built-in)
  :demand
  :custom
  (auto-revert-interval 3)
  (global-auto-revert-non-file-buffers t)
  :config
  (global-auto-revert-mode 1))

(use-package recentf :straight (:type built-in)
  :demand
  :preface
  (defun +/undo-kill-buffer (arg)
    "Re-open the last buffer killed.  With ARG, re-open the nth buffer."
    (interactive "p")
    (let ((recently-killed-list (copy-sequence recentf-list))
	  (buffer-files-list
	   (delq nil (mapcar (lambda (buf)
			       (when (buffer-file-name buf)
				 (expand-file-name (buffer-file-name buf)))) (buffer-list)))))
      (mapc
       (lambda (buf-file)
	 (setq recently-killed-list
	       (delq buf-file recently-killed-list)))
       buffer-files-list)
      (find-file
       (if arg (nth arg recently-killed-list)
	 (car recently-killed-list)))))
  :custom
  (recentf-max-menu-items 16)
  (recentf-max-saved-items 16)
  :config
  (recentf-mode 1)
  (with-eval-after-load 'no-littering
    (add-to-list 'recentf-exclude no-littering-var-directory)
    (add-to-list 'recentf-exclude no-littering-etc-directory)))

(use-package org :straight (:type built-in)
  :preface
  (defun +/org-babel-tangle-config ()
    "Tangle a configuration file automatically after save"
    (let ((conf '("CONFIG.org" "README.org" "RUNCOM.org" "TANGLE.org"))
	  (file (file-name-nondirectory(expand-file-name (buffer-file-name)))))
      (when (member file conf)
	(org-babel-tangle))))
  :gfhook
  #'(lambda () (add-hook 'after-save-hook #'+/org-babel-tangle-config))
  ;; #'variable-pitch-mode ;; #'auto-fill-mode ;; #'turn-on-auto-fill
  :config
  (setq
   org-hide-leading-stars t  ; Non-nil means hide the first N-1 stars in a headline
   org-image-actual-width 300
   org-src-fontify-natively t
   org-hide-emphasis-markers nil
   org-ellipsis " ↴"  ; The ellipsis to use in the Org mode outline (▾  ↴)
   )
  (setq org-fontify-quote-and-verse-blocks t)
  
  (dolist (face 
    '((org-level-1 . 1.2)
  	(org-level-2 . 1.18)
  	(org-level-3 . 1.16)
  	(org-level-4 . 1.14)
  	(org-level-5 . 1.12)
  	(org-level-6 . 1.1)
  	(org-level-7 . 1.1)
  	(org-level-8 . 1.1)))
    (set-face-attribute (car face) nil
  	   :font "Ubuntu"
  	   :weight 'medium
  	   :height (cdr face)))
  
  ;(set-face-attribute 'org-document-title nil :font "FiraCode Nerd Font" :weight 'bold :height 1.3)
  
  ; Ensure that anything that should be fixed-pitch in Org files appears that way
  ; (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  ; (set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
  ; (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  ; (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  ; (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  ; (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  ; (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  ; (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  ; (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  
  ; ; Get rid of the background on column views
  ; (set-face-attribute 'org-column nil :background nil)
  ; (set-face-attribute 'org-column-title nil :background nil)
  ; '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
  ; '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  ; '(org-property-value ((t (:inherit fixed-pitch))) t)
  ; '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  ; '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
  ; '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
  ; '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))
    ;  (org-babel-do-load-languages
    ;	'org-babel-load-languages
    ;	'((emacs-lisp . t)
    ;	  (ledger . t)))
  
    ;(defun org-babel-tangle-block()
    ;  (interactive)
    ;  (let ((current-prefix-arg '(4)))
    ;    (call-interactively 'org-babel-tangle)
    ;))
  
    ; Conf files highlit
  ;(push '("conf-unix" . conf-unix) org-src-lang-modes)
  
  ; Confirm before evaluation
  (setq org-confirm-babel-evaluate nil
     org-src-tab-acts-natively t)
  
  ; Local Variables:
  ; eval: (add-hook 'after-save-hook (lambda () (org-babel-tangle)) nil t)
  ; End:
  ;; (add-to-list 'safe-local-variable-values
        ;; '(eval add-hook 'after-save-hook (lambda () (org-babel-tangle)) nil t))
  (setq
   org-babel-tangle-use-relative-file-links nil
   org-babel-tangle-lang-exts '(("vala" . "vala")
  			      ("ruby" . "rb")
  			      ("python" . "py")
  			      ("picolisp" . "l")
  			      ("ocaml" . "ml")
  			      ("maxima" . "max")
  			      ("lua" . "lua")
  			      ("lisp" . "lisp")
  			      ("LilyPond" . "ly")
  			      ("latex" . "tex")
  			      ("java" . "java")
  			      ("haskell" . "hs")
  			      ("groovy" . "groovy")
  			      ("clojurescript" . "cljs")
  			      ("clojure" . "clj")
  			      ("D" . "d")
  			      ("C++" . "cpp")
  			      ("emacs-lisp" . "el")
  			      ("elisp" . "el"))
  )
  (setq org-export-backends '(ascii html icalendar latex man md odt org))
  (setq org-odt-preferred-output-format "pdf")  ; Require LibreOffice (docx)
  (setq org-odt-category-map-alist
        '(("__Figure__" "Illustration" "value" "Figure" org-odt--enumerable-image-p)))
  (setq org-export-in-background t
     org-export-with-toc nil)
  (setq org-cycle-separator-lines 2)
  (setq
   org-edit-src-content-indentation 0
   org-src-window-setup 'current-window
   org-src-preserve-indentation nil
   org-src-lang-modes '(("C" . c)
  		     ("C++" . c++)
  		     ("asymptote" . asy)
  		     ("bash" . sh)
  		     ("beamer" . latex)
  		     ("calc" . fundamental)
  		     ("cpp" . c++)
  		     ("ditaa" . artist)
  		     ("dot" . fundamental)
  		     ("elisp" . emacs-lisp)
  		     ("ocaml" . tuareg)
  		     ("screen" . shell-script)
  		     ("shell" . sh)
  		     ("gdscript" . gdscript)
  		     ("vimrc" . vimrc)
  		     ("yaml" . yaml)
  		     ("opml" . nxml)
  		     ("sqlite" . sql))
  )
  
  ;; (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (setq org-use-property-inheritance t)
  ;; (org-align-all-tags)
  (setq org-tags-column (- 68 (window-body-width)))
  (setq
  org-startup-align-all-tables t  ; Non-nil means align all tables when visiting a file
  org-startup-truncated nil  ; Non-nil means entering Org mode will set truncate-lines
  org-startup-with-inline-images t
  org-startup-folded t  ; Non-nil means entering Org mode will switch to OVERVIEW
  org-hide-block-startup nil
  org-startup-indented nil  ; Non-nil means turn on org-indent-mode on startup
  )  
  
  ;; (setq org-clock-persist 'history)
  ;; (org-clock-persistence-insinuate)
  ;; (setq system-time-locale "C") 
  :custom
  (org-support-shift-select 'always)
  (org-modules '(ol-w3m ol-bbdb ol-bibtex ol-docview ol-gnus ol-info ol-irc ol-eww
		 org-habit org-bookmark org-eshell org-tempo))
;; org-toc
  :general
  (:keymaps 'org-capture-mode-map
	    [remap evil-save-and-close]          'org-capture-finalize
	    [remap evil-save-modified-and-close] 'org-capture-finalize
	    [remap evil-quit]                    'org-capture-kill)
  (:states 'normal :keymaps 'org-mode-map
	   "M-j" #'org-next-visible-heading
	   "M-k" #'org-previous-visible-heading
	   "C-j" #'org-metadown
	   "C-'" #'org-edit-special
	   "M-/" '(consult-org-heading :package consult)

	   "C-k" #'org-metaup)

  (:states 'normal :keymaps 'org-src-mode-map
	   "C-'" "C-c '")
  (leader-def :keymaps 'org-mode-map
    "o" '(:ignore t :which-key "org")
    "o d" #'(org-babel-demarcate-block :wk "demarcate block")
    "o c" #'(org-capture :wk "capture")
    "o ;" #'(org-toggle-comment :wk "toggle comment")
    "o :" #'(org-toggle-link-display :wk "toggle link display")
    "o f" #'(org-switchb :wk "switch to agenda file")
    ;; "o t" #'(org-todo :wk "todo")
    "o l" #'(org-store-link :wk "store link")))

(use-package org-roam
  :preface
  (defun +/org-roam-node-insert-immediate (arg &rest args)
    (interactive "P")
    (let ((args (cons arg args))
          (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                    '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args)))
  :custom
  (org-roam-directory (file-truename "/mnt/files/Ricardo/Documents/note"))
  :config
  (org-roam-db-autosync-mode)
  :general
  (leader-def
    "n" '(:ignore t :which-key "note")
    "n b" #'(org-roam-buffer-toggle :wk "buffer")
    "n f" #'(org-roam-node-find :wk "find node")
    "n i" #'(org-roam-node-insert :wk "insert node")
    "n I" #'(+/org-roam-node-insert-immediate :wk "insert node immediate")
))

(use-package org-agenda :straight (:type built-in)
  :config
  (setq
  org-agenda-files "/home/user/.config/emacs/agenda-file"
  org-agenda-file-regexp "\\`[^.].*\\(\\.org\\)?\\'"
  org-agenda-sticky t

  ; Start
  org-agenda-start-with-log-mode t

  ; Window
  org-agenda-window-setup 'only-window
  org-agenda-restore-windows-after-quit t

  ; Daily/Weekly
  org-agenda-span 'week
  org-agenda-include-diary nil
  )
  :general
  (leader-def
    "o a"   #'(org-agenda :wk "agenda")
    ;; "" #'(org-agenda-file-to-front :wk "file to front")
  )

  ;; 'org-agenda-mode-map 
  ;; org-toggle-sticky-agenda
)

(use-package org-superstar
  :after org
  :ghook 'org-mode-hook
  :custom
  (org-superstar-headline-bullets-list '("●" "◉" "○" "◉" "○"))
  :config ())  ; Show message if verbose is activated

(use-package visual-fill-column
  :hook (visual-line-mode . visual-fill-column-mode)
  ; Disable
  ((mhtml-mode) . (lambda () (visual-fill-column-mode 0)))
  :custom
  (visual-fill-column-width 128)
  (visual-fill-column-center-text t)
  :config ())  ; Show message if verbose is activated

(use-package saveplace
  :straight (:type built-in)
  :demand
  :config
  (save-place-mode 1))

(use-package eshell :straight (:type built-in)
  ;; :gfhook ('eshell-pre-command-hook #'eshell-save-some-history)
  :custom
  (eshell-history-size 6000)
  (eshell-buffer-maximum-lines 6000)
  (eshell-hist-ignoredups t)
  (eshell-scroll-to-bottom-on-input t)
  :config
  ; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)
  :general
  (leader-def
	"e s" '(eshell :which-key "Eshell")))

;;Running programs in a term-mode buffer
;(with-eval-after-load 'esh-opt
;  (setq eshell-destroy-buffer-when-process-dies t)
;  (setq eshell-visual-commands '("htop" "zsh" "vim")))

(use-package eshell-git-prompt
  :after eshell
  :demand
  :config
  (eshell-git-prompt-use-theme 'powerline))

;(server-start)  ; Allow this Emacs process to be a server for client processes
;(setq show-value-server-raise-frame t)  ; If non-nil, raise frame when switching to a buffer
;(setq server-window (pop-to-buffer (current-buffer) t)) ; Specification of the window to use for selecting Emacs server buffers

(use-package magit
  ;; :custom
  ;; (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :config
  (with-eval-after-load 'magit-mode (add-hook 'after-save-hook 'magit-after-save-refresh-status t))
  ;; Remove some functions
  ;; (with-eval-after-load 'magit-diff
  ;; 	(remove-hook 'magit-section-movement-hook
  ;; 				 'magit-hunk-set-window-start))
  :general
  (leader-def
    "g"     '(:ignore t :which-key "magit")
    "g s"   'magit-status
    "g d"   'magit-diff-unstaged
    "g c"   'magit-branch-or-checkout
    "g l"   '(:ignore t :which-key "log")
    "g l c" 'magit-log-current
    "g l f" 'magit-log-buffer-file
    "g b"   'magit-branch
    "g P"   'magit-push-current
    "g p"   'magit-pull-branch
    "g f"   'magit-fetch
    "g F"   'magit-fetch-all
    "g r"   'magit-rebase))

(use-package gdscript-mode
  :preface
  (defun +/lsp--gdscript-ignore-errors (original-function &rest args)
	"Ignore the error message resulting from Godot not replying to the `JSONRPC' request."
	(if (string-equal major-mode "gdscript-mode")
		(let ((json-data (nth 0 args)))
		  (if (and (string= (gethash "jsonrpc" json-data "") "2.0")
				   (not (gethash "id" json-data nil))
				   (not (gethash "method" json-data nil)))
			  nil ; (message "Method not found")
			(apply original-function args)))
	  (apply original-function args)))
  :custom
  (gdscript-use-tab-indents t)
  (gdscript-indent-offset 4)
  (gdscript-godot-executable "/bin/godot")
  (gdscript-gdformat-save-and-format t)
  :config
  ;; Runs the function `+/lsp--gdscript-ignore-errors` around `lsp--get-message-type` to suppress unknown notification errors.
  (advice-add #'lsp--get-message-type :around #'+/lsp--gdscript-ignore-errors))

(use-package prog-mode :straight (:type built-in)
  :demand
  :custom
  (prettify-symbols-unprettify-at-point 'right-edge)
  (prettify-symbols-alist '())
  :config
  (global-prettify-symbols-mode 1)

  (setq prettify-symbols-alist '(("TODO" . "")
	                         ("WAIT" . "")        
   				 ("NOPE" . "")
				 ("DONE" . "")
				 ("[#A]" . "")
				 ("[#B]" . "")
 				 ("[#C]" . "")
				 ("[ ]" . "")
				 ("[X]" . "")
				 ("[-]" . "")
				 ("#+BEGIN_SRC" . "")
				 ("#+END_SRC" . "―")
				 (":PROPERTIES:" . "")
				 (":END:" . "―")
				 ("#+STARTUP:" . "")
				 ("#+TITLE: " . "")
				 ("#+RESULTS:" . "")
				 ("#+NAME:" . "")
				 ("#+ROAM_TAGS:" . "")
				 ("#+FILETAGS:" . "")
				 ("#+HTML_HEAD:" . "")
				 ("#+SUBTITLE:" . "")
				 ("#+AUTHOR:" . "")
				 (":Effort:" . "")
				 ("SCHEDULED:" . "")
				 ("DEADLINE:" . "")
				 ("lambda" . 955)
				 ))
)

(use-package csharp-mode)

(use-package yaml-mode
  ;; :general
  ;; ('yaml-mode-map "\C-m" 'newline-and-indent)
)

(use-package web-mode)

(use-package vimrc-mode)
;; (add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :preface
  (defun +/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless))) ;; Configure orderless
          ;; '(flex) ;; Configure flex (built-in)
  :hook
  ((
    mhtml-mode
    css-mode
    js-mode  ; ts-ls
    ;; c++-mode
    ;; sh-mode
    ;; python-mode
    gdscript-mode
  ) . lsp-deferred)
  (lsp-completion-mode . +/lsp-mode-setup-completion)
  (lsp-mode . lsp-enable-which-key-integration)  ; Which-key integration
  :custom
  (lsp-completion-provider :none) ; we use corfu!
  (lsp-keymap-prefix "C-c l")
;;   (lsp-modeline-diagnostics-scope :workspace)
;;   (lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
;;   (lsp-modeline-code-actions-segments '(count icon name))
  :config
  (setq-local completion-at-point-functions (list (cape-capf-buster #'lsp-completion-at-point)))
;;   (lsp-headerline-breadcrumb-mode 1)
;;   (lsp-modeline-code-actions-mode 1)
  ;; :general
  ;; (leader-def :keymaps 'lsp-mode-map
    ;; "l" '(:ignore t :which-key "lsp")
  ;; )
)

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :custom
  (lsp-ui-sideline-mode 1)
  ; Sideline
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-update-mode #'point)
  (lsp-ui-sideline-delay 0.6)
  ; Peek
  (lsp-ui-peek-enable t)
  (lsp-ui-peek-show-directory t)
  ; Doc
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-delay 6.0)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-doc-show-with-mouse t)
  ; Imenu
  (lsp-ui-imenu-window-width 16)
  (lsp-ui-imenu--custom-mode-line-format nil)
  (lsp-ui-imenu-auto-refresh nil)
  (lsp-ui-imenu-refresh-delay nil)
  ;; :general
  ;; (:keymaps 'lsp-ui-mode-map
  ;;   "l p" '(:ignore t :which-key "peek")
  ;;   "l p d" #'(lsp-ui-peek-find-definitions :wk "definition")
  ;;   "l p r" #'(lsp-ui-peek-find-references :wk "reference")
  ;;   "l p w" #'(lsp-ui-peek-find-workspace-symbol :wk "workspace symbol")
  ;;   "l p i" #'(lsp-ui-peek-find-implementation :wk "implementation")
  ;;   "l p b" #'(lsp-ui-peek-jump-backward :wk "jump backward")
  ;;   "l p f" #'(lsp-ui-peek-jump-forward :wk "jump forward")
  ;; )
)

(use-package projectile
  :demand
  :custom
  (projectile-discover-projects-in-search-path t)
  (projectile-project-search-path
   '("/mnt/files/Ricardo/Projects"))
  :config
  (projectile-register-project-type 'godot '("project.godot")
                                    :project-file "project.godot"
				    :compile "godot --help"
				    :test "godot --help"
				    :run "godot --help")
  :general
  (leader-def
    "p" '(projectile-command-map :which-key "project")
    "p" '(:ignore t :which-key "project")
    "p f" '(projectile-find-file :which-key "file")
    "p d" '(projectile-find-dir :which-key "directory")
    "p k" '(projectile-kill-buffers :which-key "kill buffers")
  )
)

(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete)
  :general
  (leader-def
    "e r" #'((lambda () (interactive) (load-file "~/.config/emacs/init.el")) :wk "reload emacs config")
    "e k" #'(kill-emacs :wk "kill emacs")
  )
)

(use-package alert
:demand
:custom
(alert-default-style 'libnotify)
(alert-fade-time 10)
;; :config
;; (alert-add-rule :status   '(buried visible idle)
                ;; :severity '(moderate high urgent)
                ;; :mode     'evil-smartparens-mode
                ;; :style 'ignore
                ;; :continue t)
)

(use-package org-wild-notifier
:after org-mode
:demand
:custom
(org-wild-notifier-alert-time '(1))
(org-wild-notifier-notification-title "Agenda")
(org-wild-notifier-notification-icon nil)
(org-wild-notifier-keyword-whitelist '("TODO"))
(org-wild-notifier-keyword-blacklist nil)
(org-wild-notifier-tags-whitelist nil)
(org-wild-notifier-tags-blacklist nil)
(org-wild-notifier-alert-times-property	"WILD_NOTIFIER_NOTIFY_BEFORE")
:config
(org-wild-notifier-mode 1))

(use-package display-line-numbers :straight (:type built-in)
  :hook ((prog-mode conf-mode) . display-line-numbers-mode)
  :config ())  ; Show message if verbose is activated




; Disable line numbers for some modes
;; (defcustom display-line-numbers-exempt-modes
;;   '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
;;   "Major modes on which to disable line numbers."
;;   :group 'display-line-numbers
;;   :type 'list
;;   :version "green")

;; (defun display-line-numbers--turn-on ()
;;   "Turn on line numbers except for certain major modes.
;; Exempt major modes are defined in `display-line-numbers-exempt-modes'."
;;   (unless (or (minibufferp)
;;               (member major-mode display-line-numbers-exempt-modes))
;;     (display-line-numbers-mode)))

;; (global-display-line-numbers-mode)






;; (dolist (mode '(term-mode-hook
;; 		dashboard-mode-hook
;; 		org-mode-hook
;; 		treemacs-mode-hook
;; 		eshell-mode-hook))
;;   (add-hook mode (lambda () (display-line-numbers-mode 0))))

; Don't pop up UI dialogs when prompting
(setq use-dialog-box nil)

(use-package vertico
  :demand
  :preface
  (defun +/vertico-backward-updir ()
	"Delete char before or go up directory for file cagetory vertico buffers."
	(interactive)
	(let ((metadata (completion-metadata (minibuffer-contents)
   										 minibuffer-completion-table
   										 minibuffer-completion-predicate)))
	  (if (and (eq (char-before) ?/)
   			   (eq (completion-metadata-get metadata 'category) 'file))
   		  (let ((new-path (minibuffer-contents)))
   			(delete-region (minibuffer-prompt-end) (point-max))
   			(insert (abbreviate-file-name
   					 (file-name-directory
   					  (directory-file-name
   					   (expand-file-name new-path))))))
   		(call-interactively 'backward-delete-char))))
  :custom
  (vertico-count 16)
  (vertico-cycle t)  ; Optionally enable cycling for `vertico-next' and `vertico-previous'
  (vertico-resize nil)  ; Grow and shrink the Vertico minibuffer
  ;; (enable-recursive-minibuffers t)  ; Enable recursive minibuffers
  :config
  (vertico-mode 1)
  ;; (setq minibuffer-prompt-properties  ; Do not allow the cursor in the minibuffer prompt
  ;; 		'(read-only t cursor-intangible t face minibuffer-prompt))
  ;; (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  :general
  (vertico-map
   "M-j" #'vertico-next
   "M-S-j" #'vertico-next-group
   "M-k" #'vertico-previous
   "M-S-k" #'vertico-previous-group
   "M-RET" #'vertico-exit-input
   "<backspace>" #'+/vertico-backward-updir)
  (minibuffer-local-map
   "M-h" #'backward-kill-word))

(use-package consult
  :config
  ; Optionally configure a function which returns the project root directory.
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-root-function #'projectile-project-root)
  :general
  (leader-def
    ":" 'consult-complex-command
    "@" 'consult-register
    "#" 'consult-register-load
    "'" 'consult-register-store
    
    "c h" 'consult-history
    "c m" 'consult-mode-command
    "c b" 'consult-bookmark
    "c k" 'consult-kmacro

    "SPC" '(consult-buffer :which-key "Switch to buffer")
    "b w" '(consult-buffer-other-window :which-key "Switch to buffer other window")
    "b f" '(consult-buffer-other-frame :which-key "Switch to buffer other frame")

    "g l" 'consult-goto-line
    "g e" 'consult-compile-error
    "g f" 'consult-flymake  ;; Alternative: consult-flycheck
    "g o" 'consult-outline
    "g m" 'consult-mark
    "g k" 'consult-global-mark
    "g i" 'consult-imenu
    "g I" 'consult-imenu-multi

    "f r" '(consult-recent-file :wk "recent-file")

    "s f" 'consult-find
    "s F" 'consult-locate
    "s g" 'consult-grep
    "s G" 'consult-git-grep
    "s r" 'consult-ripgrep
    "s l" 'consult-line
    "s L" 'consult-line-multi
    "s m" 'consult-multi-occur
    "s k" 'consult-keep-lines
    "s u" 'consult-focus-lines
	"s e" 'consult-isearch))

(use-package marginalia
  :demand
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :general
  (minibuffer-local-map
   "M-a" #'marginalia-cycle)
  :config
  (marginalia-mode 1))

(use-package orderless
  :demand
  :custom
  (completion-styles '(orderless))
  ;; (orderless-component-separator "[ &]")
  ;; (orderless-component-separator "[ +]")
  ;; (completion-category-defaults nil)
  ;; (completion-category-overrides '((file (styles . (orderless partial-completion)))))
  :config
  ;; ...otherwise find-file gets different highlighting than other commands
  ;; (set-face-attribute 'completions-first-difference nil :inherit nil)

  ;; (setq orderless-style-dispatchers
  ;; 	'(lambda (pattern _index _total) 
  ;; 	   (cond
  ;; 	    Ensure $ works with Consult commands, which add disambiguation suffixes
  ;; 	    ((string-suffix-p "$" pattern)
  ;; 	     `(orderless-regexp . ,(concat (substring pattern 0 -1) "[\x100000-\x10FFFD]*$")))
  ;; 	    ;; Ignore single !
  ;; 	    ((string= "!" pattern) `(orderless-literal . ""))
  ;; 	    ;; Without literal
  ;; 	    ((string-prefix-p "!" pattern) `(orderless-without-literal . ,(substring pattern 1)))
  ;; 	    ;; Initialism matching
  ;; 	    ((string-prefix-p "`" pattern) `(orderless-initialism . ,(substring pattern 1)))
  ;; 	    ((string-suffix-p "`" pattern) `(orderless-initialism . ,(substring pattern 0 -1)))
  ;; 	    ;; Literal matching
  ;; 	    ((string-prefix-p "=" pattern) `(orderless-literal . ,(substring pattern 1)))
  ;; 	    ((string-suffix-p "=" pattern) `(orderless-literal . ,(substring pattern 0 -1)))
  ;; 	    ;; Flex matching
  ;; 	    ((string-prefix-p "~" pattern) `(orderless-flex . ,(substring pattern 1)))
  ;; 	    ((string-suffix-p "~" pattern) `(orderless-flex . ,(substring pattern 0 -1))))))
)

(use-package savehist
  :demand
  :config
  (setq history-length 16)
  (savehist-mode 1)
)

(use-package doom-modeline
  :after doom-themes
  :demand
  :custom
  (column-number-mode t)
  (inhibit-compacting-font-caches t)
  (doom-modeline-height 16)  ; How tall the mode-line should be
  (doom-modeline-icon t)  ; Whether display icons in the mode-line
  (doom-modeline-indent-info nil)  ; Whether display the indentation information
  :config
  (doom-modeline-mode 1))

(use-package solaire-mode
  :demand
  ;; :hook
  ;; ((change-major-mode after-revert ediff-prepare-buffer) . turn-on-solaire-mode)
  ;; (minibuffer-setup . solaire-mode-fix-minibuffer)
;;   ((messages-buffer-mode dashboard-mode lisp-interaction-mode) . (lambda () (solaire-mode 0)))
  :config
  (solaire-global-mode 1)
  ;; (add-hook 'after-make-frame-functions
  ;;           (lambda (_frame)
  ;;             (load-theme 'doom-one t)
  ;;             (solaire-mode-swap-bg)))
)

(use-package highlight-indent-guides
  :hook ((prog-mode conf-mode org-mode) . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-suppress-auto-error t)
  (highlight-indent-guides-character 9474)  ; | 124  ⇥ 8677  ⇨ 8680  ↦ 8614 default 9474
  (highlight-indent-guides-method 'character)  ; Method to use when displaying indent guides
  (highlight-indent-guides-responsive 'stack)
  (highlight-indent-guides-auto-enabled t)
  )

  ;; :config
  ;; (when doom-theme
    ;; (+/indent-guides-init-faces-h))

  ;; ;; `highlight-indent-guides' breaks when `org-indent-mode' is active
  ;; (+/add-hook 'org-mode-local-vars-hook
  ;;   (defun +indent-guides-disable-maybe-h ()
  ;;     (and highlight-indent-guides-mode
  ;;          (bound-and-true-p org-indent-mode)
  ;;          (highlight-indent-guides-mode -1))))

(use-package helpful
  :general
  (leader-def
    "h" '(:ignore t :which-key "help")
    "h f" #'(helpful-callable :wk "callable")
    "h F" #'(helpful-function :wk "function")
    "h o" #'(helpful-symbol :wk "symbol")
    "h v" #'(helpful-variable :wk "variable")
    "h c" #'(helpful-command :wk "command")
    "h k" #'(helpful-key :wk "key")
    "h i" #'(info :wk "info")
    "h r" #'(info-emacs-manual :wk "emacs manual")
    "h a" #'(consult-apropos :wk "apropos")
    "h s" #'(describe-syntax :wk "syntax")
    "h O" #'((lambda () (interactive) (info "org")) :wk "org manual")
    "h R" #'((lambda () (interactive) (info "elisp")) :wk "elisp manual"))
  :config ())  ; Show message if verbose is activated

;; ‘window-setup-hook’ or ‘tty-setup-hook’
(use-package which-key
  :demand
  :custom
  (which-key-idle-delay 0.4)
  :config
  (which-key-mode))

(use-package customize :straight (:type built-in)
  :custom
  (custom-file (locate-user-emacs-file "custom-vars.el"))
  :config
  (load custom-file 'noerror 'nomessage))
