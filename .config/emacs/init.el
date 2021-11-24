(defun +/display-startup-time ()
  "Show the duration of emacs startup"
  (let ((package-count 0) (time (emacs-init-time)))
    (when (bound-and-true-p package-alist)
  (setq package-count (length package-activated-list)))
    (when (boundp 'straight--profile-cache)
  (setq package-count (+ (hash-table-size straight--profile-cache) package-count)))
    (if (zerop package-count)
	(message "Emacs started in %.4s with %d garbage collections"
		 time gcs-done)
  (message "%d packages loaded in %.4s with %d garbage collections"
	   package-count time gcs-done))))

(defun +/unquote (exp)
  "Return EXP unquoted."
  (declare (pure t) (side-effect-free t))
  (while (memq (car-safe exp) '(quote function))
    (setq exp (cadr exp)))
  exp)

(defun +/enlist (exp)
  "Return EXP wrapped in a list, or as-is if already a list."
  (declare (pure t) (side-effect-free t))
  (if (listp exp) exp (list exp)))

(defun +/resolve-hook-forms (hooks)
  "Converts a list of modes into a list of hook symbols.

If a mode is quoted, it is left as is. If the entire HOOKS list is quoted, the
list is returned as-is."
  (declare (pure t) (side-effect-free t))
  (let ((hook-list (+/enlist (+/unquote hooks))))
    (if (eq (car-safe hooks) 'quote)
	hook-list
  (cl-loop for hook in hook-list
	   if (eq (car-safe hook) 'quote)
	   collect (cadr hook)
	   else collect (intern (format "%s-hook" (symbol-name hook)))))))

(defmacro +/add-hook (hooks &rest rest)
  "A convenience macro for adding N functions to M hooks.

This macro accepts, in order:

  1. The mode(s) or hook(s) to add to. This is either an unquoted mode, an
     unquoted list of modes, a quoted hook variable or a quoted list of hook
     variables.
  2. Optional properties :local, :append, and/or :depth [N], which will make the
     hook buffer-local or append to the list of hooks (respectively),
  3. The function(s) to be added: this can be one function, a quoted list
     thereof, a list of `defun's, or body forms (implicitly wrapped in a
     lambda).

\(fn HOOKS [:append :local] FUNCTIONS)"
  (declare (indent (lambda (indent-point state)
		     (goto-char indent-point)
		     (when (looking-at-p "\\s-*(")
		   (lisp-indent-defform state indent-point))))
	   (debug t))
  (let* ((hook-forms (+/resolve-hook-forms hooks))
	 (func-forms ())
	 (defn-forms ())
	 append-p
	 local-p
	 remove-p
	 depth
	 forms)
    (while (keywordp (car rest))
  (pcase (pop rest)
	(:append (setq append-p t))
	(:depth  (setq depth (pop rest)))
	(:local  (setq local-p t))
	(:remove (setq remove-p t))))
    (let ((first (car-safe (car rest))))
  (cond ((null first)
	     (setq func-forms rest))

	    ((eq first 'defun)
	     (setq func-forms (mapcar #'cadr rest)
		   defn-forms rest))

	    ((memq first '(quote function))
	     (setq func-forms
		   (if (cdr rest)
		   (mapcar #'+/unquote rest)
		     (+/enlist (+/unquote (car rest))))))

	    ((setq func-forms (list `(lambda (&rest _) ,@rest)))))
  (dolist (hook hook-forms)
	(dolist (func func-forms)
	  (push (if remove-p
		    `(remove-hook ',hook #',func ,local-p)
		  `(add-hook ',hook #',func ,(or depth append-p) ,local-p))
		forms)))
  (macroexp-progn
   (append defn-forms
	   (if append-p
		   (nreverse forms)
		 forms))))))

; Install straight if not installed
(defvar bootstrap-version)
(let ((bootstrap-file
	   (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
	  (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
	(with-current-buffer
		(url-retrieve-synchronously
		 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
		 'silent 'inhibit-cookies)
	  (goto-char (point-max))
	  (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

; Use package.el
;(unless (package-installed-p 'use-package)
;  (package-install 'use-package))
;(eval-when-compile
;  (require 'use-package))

; Use straight.el
(straight-use-package 'use-package)

(setq straight-enable-use-package-integration t)
(setq straight-use-package-by-default t)

(setq use-package-always-defer t  
	  use-package-always-pin t
	  use-package-always-ensure nil
	  use-package-verbose nil)

(use-package gcmh
  :demand
  :custom
  (garbage-collection-messages nil)
  (gcmh-verbose nil)
  ;(gcmh-high-cons-threshold)
  ;(gc-cons-threshold (* 50 1000 1000))  ; The default is 800 kilobytes
  ;(gc-cons-threshold (* 2 1000 1000))  ; Make gc pauses faster by decreasing the threshold
  :config ())  ; Show message if verbose is activated

(use-package doom-themes
  :demand
  :custom
  (doom-themes-enable-bold t)  ; If nil, bold will be disabled across all faces
  (doom-themes-enable-italic t)  ; If nil, italics will be disabled across all faces
  (doom-themes-padded-modeline nil)  ; Default value for padded-modeline setting for themes that support it
  (doom-themes-treemacs-theme "doom-atom")
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)  ; Enable flashing the mode-line on error
  (doom-themes-treemacs-config)  ; Install doom-themes' treemacs configuration
  (doom-themes-org-config))  ; Corrects (and improves) org-mode's native fontification

(use-package doom-modeline
  :demand
  :custom
  (doom-modeline-height 16)  ; How tall the mode-line should be
  (doom-modeline-icon t)  ; Whether display icons in the mode-line
  (doom-modeline-indent-info nil)  ; Whether display the indentation information
  :config
  (doom-modeline-mode 1))  ; Show message if verbose is activated

(use-package exec-path-from-shell
  :demand
  :config
  ;(pcase system-type
  ;  ('gnu/linux "It's Linux!")
  ;  ('windows-nt "It's Windows!")
  ;  ('darwin "It's macOS!"))
  (when (memq system-type '(gnu/linux darwin))
	(exec-path-from-shell-initialize)))

(use-package no-littering
  :demand
  :init
  (setq 
   no-littering-etc-directory (expand-file-name "conf" user-emacs-directory)
   no-littering-var-directory (expand-file-name "data" user-emacs-directory)
   custom-file (expand-file-name "custom.el" user-emacs-directory)
   auto-save-file-name-transforms `((".*" ,(no-littering-expand-var-file-name "auto-save") t))
   url-history-file (expand-file-name "data/url/history" user-emacs-directory)))

(use-package general
  :demand
  :config
  (general-auto-unbind-keys)  ; Automatic Key Unbinding

  (defconst my-leader "SPC")
  (general-create-definer my-leader-def
    :states '(normal insert visual emacs)     
    :keymaps 'override
    :prefix my-leader
    :global-prefix "C-SPC")

  (general-def "<escape>" #'keyboard-escape-quit)

  (my-leader-def
    "e r"   '((lambda () (interactive) (load-file "~/.config/emacs-vanilla/init.el")) :which-key "Reload emacs config")
    "e i"   '((lambda () (interactive) (find-file "~/.config/emacs-vanilla/README.org")) :which-key "Open emacs config")
    "e k"   '((lambda () (interactive) (kill-emacs)) :which-key "Exit the emacs job and kill it")
    "b i"   '(ibuffer :which-key "Ibuffer")
    "b k"   '(kill-current-buffer :which-key "Kill current buffer")
    "b n"   '(next-buffer :which-key "Next buffer")
    "b p"   '(previous-buffer :which-key "Previous buffer")
    "b B"   '(ibuffer-list-buffers :which-key "Ibuffer list buffers")
    "b K"   '(kill-buffer :which-key "Kill buffer")))
					;"t t"   '(toggle-truncate-lines :which-key "Toggle truncate lines")

(setq-default tab-width 4)  ; Distance between tab stops, in columns

(use-package electric
  :demand
  :custom
  (electric-indent-inhibit t)  ; Auto close bracket insertion
  (electric-pair-pairs '((?\" . ?\") (?\{ . ?\})))
  (electric-indent-chars '(?\n ?\^?))
  :config
  (electric-indent-mode 0)  ; Toggle on-the-fly reindentation 
  (electric-layout-mode 0)  ; Automatically insert newlines around some chars
  (electric-pair-mode 0))  ; Toggle automatic parens pairing

(use-package evil
  :demand
  :custom
  (evil-respect-visual-line-mode t)
  (evil-shift-width 4)
  (evil-split-window-below t)
  (evil-undo-system 'undo-tree)
  (evil-vsplit-window-right t)
  (evil-want-C-i-jump nil)
  (evil-want-C-u-scroll nil)
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-auto-indent nil)
  (evil-echo-state nil)
  :config
  (evil-mode 1)
  ;; (evil-set-initial-state 'messages-buffer-mode 'normal)
  :general
  ('motion
   "j" #'evil-next-visual-line
   "k" #'evil-previous-visual-line)
  ('insert
   "C-g" #'evil-normal-state
   "TAB" #'tab-to-tab-stop))
;; "C-h" #'evil-delete-backward-char-and-join))

(use-package evil-collection
  :demand
  :after evil
  :custom
  ;; (setq evil-collection-company-use-tng nil)  ; Is this a bug in evil-collection ?
  (evil-collection-outline-bind-tab-p nil)
  :config
  (evil-collection-init))

;; (defun counsel-imenu-comments ()
;; 	(interactive)
;; 	(let* ((imenu-create-index-function 'evilnc-imenu-create-index-function))
;; 	  (unless (featurep 'counsel) (require 'counsel))
;; 	  (counsel-imenu)))

(use-package evil-nerd-commenter
  :after evil
  :general
  ("C-;" 'evilnc-comment-or-uncomment-lines))

(use-package vi-tilde-fringe
  :ghook '(conf-mode-hook prog-mode-hook text-mode-hook)
  :gfhook ('(org-mode-hook
			 dashboard-mode-hook) #'(lambda () (vi-tilde-fringe-mode 0)))  ; Disable for some modes
  :config ())  ; Show message if verbose is activated

(setq-default indent-tabs-mode t)

(setq backward-delete-char-untabify-method 'hungry)

; Zoom In/Out
(general-def
  "<C-wheel-up>" 'text-scale-increase
  "<C-wheel-down>" 'text-scale-decrease)

(use-package smartparens
  :hook ((prog-mode
		  text-mode
		  conf-mode) . (lambda ()
						 (smartparens-mode 1)
						 (show-smartparens-mode 1)))
  :config ())  ; Show message if verbose is activated
  ;; :config
  ;; (add-hook 'minibuffer-setup-hook 'turn-on-smartparens-strict-mode))
  ;; (smartparens-global-strict-mode 1))
;;sp-ignore-mode-list

(use-package undo-tree
  :hook (after-init . global-undo-tree-mode)
  :config ())  ; Show message if verbose is activated

(use-package yasnippet
  :ghook ('(conf-mode-hook prog-mode-hook text-mode-hook) #'yas-minor-mode)
  :config ())  ; Show message if verbose is activated

(use-package doom-snippets
  :after yasnippet
  :straight (doom-snippets :type git :host github :repo "hlissner/doom-snippets" :files ("*.el" "*")))

(use-package all-the-icons
  :demand
  :config ())  ; Show message if verbose is activated

(use-package centaur-tabs
  :preface
  (defun centaur-tabs-buffer-groups ()
    "`centaur-tabs-buffer-groups' control buffers' group rules.

    Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
    All buffer name start with * will group to \"Emacs\".
    Other buffer group by `centaur-tabs-get-group-name' with project name."
    (list
     (cond
	  ((or (string-equal "*" (substring (buffer-name) 0 1))
	   (memq major-mode '(magit-process-mode
			  magit-status-mode
			  magit-diff-mode
			  magit-log-mode
			  magit-file-mode
			  magit-blob-mode
			  magit-blame-mode
			  )))
   "Emacs")
  ((derived-mode-p 'prog-mode)
   "Prog")
  ((derived-mode-p 'dired-mode)
   "Dired")
  ((memq major-mode '(helpful-mode
					  help-mode))
   "Help")
  ((memq major-mode '(org-mode
			  org-agenda-clockreport-mode
			  org-src-mode
			  org-agenda-mode
			  org-beamer-mode
			  org-indent-mode
			  org-bullets-mode
			  org-cdlatex-mode
			  org-agenda-log-mode
			  diary-mode))
   "Org")
  (t
   (centaur-tabs-get-group-name (current-buffer))))))
  :hook (after-init . centaur-tabs-mode) 
  ; Disable centaur-tabs in selected buffers
  ((dired-mode 
    dashboard-mode 
    help-mode
    helpful-mode
	special-mode
    term-mode
    delayed-warning
	debugger-mode
    calendar-mode
	ibuffer-mode
	buffer-menu-mode
	messages-buffer-mode
    org-agenda-mode
    helpful-mode
    popup-buffer-mode) . centaur-tabs-local-mode)
  :custom
  (centaur-tabs-style "bar")
  (centaur-tabs-height 32)
  (centaur-tabs-set-icons t)
  (centaur-tabs-plain-icons nil)
  (centaur-tabs-gray-out-icons 'buffer)
  (centaur-tabs-set-bar 'left)
  ;; (x-underline-at-descent-line t)  ; Set this only if centaur-tabs-set-bar is 'under
  (centaur-tabs-set-modified-marker t)
  (centaur-tabs-close-button "✕")
  (centaur-tabs-modified-marker "•")
  (centaur-tabs-cycle-scope 'tabs)
  :config
  (centaur-tabs-mode 1)
  (centaur-tabs-group-by-projectile-project)  ; Group by projectile project

  (defun centaur-tabs-hide-tab (x)
    "Do no to show buffer X in tabs."
    (let ((name (format "%s" x)))
  (or
   ;; Current window is not dedicated window.
   (window-dedicated-p (selected-window))

   ;; Buffer name not match below blacklist.
   (string-prefix-p "*epc" name)
   (string-prefix-p "*helm" name)
   (string-prefix-p "*Helm" name)
   (string-prefix-p "*Compile-Log*" name)
   (string-prefix-p "*lsp" name)
   (string-prefix-p "*company" name)
   (string-prefix-p "*Flycheck" name)
   (string-prefix-p "*tramp" name)
   (string-prefix-p " *Mini" name)
   (string-prefix-p "*help" name)
   (string-prefix-p "*straight" name)
   (string-prefix-p " *temp" name)
   (string-prefix-p "*Help" name)
   (string-prefix-p "*mybuf" name)

   ;; Is not magit buffer.
   (and (string-prefix-p "magit" name)
	    (not (file-name-extension name)))
   )))
  :general
  ;; (:states 'normal
   ;; "K" 'centaur-tabs-forward
   ;; "J" 'centaur-tabs-backward)
  (my-leader-def
    "t t" '(centaur-tabs--create-new-tab :which-key "New tab")
    "t l" '(centaur-tabs-forward-group :which-key "Go to next tab group")
    "t h" '(centaur-tabs-backward-group :which-key "Go to previous tab group")
    "t g g" '(centaur-tabs-select-beg-tab :which-key "Select the first tab of the group")
    "t G" '(centaur-tabs-select-end-tab :which-key "Select the last tab of the group")
    "t s" '(centaur-tabs-counsel-switch-group :which-key "Show buffer groups")
    "t p" '(centaur-tabs-group-by-projectile-project :which-key "Group by projectile project")
    "t g" '(centaur-tabs-group-buffer-groups :which-key "Use centaur's buffer grouping")
    ; Rebind join, and lookup (default K and J vim keybindigs)
    "k" '(evil-lookup :which-key "Look up the keyword at point")
    "j" '(evil-join :which-key "Join the selected lines")))

(use-package company
  :preface
  (defun +/noweb-reference (command &optional arg &rest ignored)
	"Complete `<<' with the names of defined SRC blocks."
	(interactive (list 'interactive))
	(cl-case command
      (interactive (company-begin-backend '+/noweb-reference))
      (init (require 'org-element))
      (prefix (and (eq major-mode 'org-mode)
				   (eq 'src-block (car (org-element-at-point)))
				   (cons (company-grab-line "^<<\\(\\w*\\)" 1) t)))
      (candidates
       (org-element-map (org-element-parse-buffer) 'src-block
		 (lambda (src-block)
		   (let ((name (org-element-property :name src-block)))
			 (when name
			   (propertize
				name
				:value (org-element-property :value src-block)
				:annotation (org-element-property :raw-value (org-element-lineage src-block '(headline)))))))))
      (sorted t)            ; Show candidates in same order as doc
      (ignore-case t)
      (duplicates nil)               ; No need to remove duplicates
      (post-completion               ; Close the reference with ">>"
       (insert ">>"))
      ;; Show the contents of the block in a doc-buffer. If you have
      ;; company-quickhelp-mode enabled it will show in a popup
      (doc-buffer (company-doc-buffer (get-text-property 0 :value arg)))
      (annotation (format " [%s]" (get-text-property 0 :annotation arg)))))
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 0)
  (company-idle-delay 0.0)
  (company-backends '(company-bbdb
					  company-semantic
					  company-cmake
					  company-capf
					  ;; company-clang
					  company-files
					  (company-dabbrev-code company-gtags company-etags company-keywords)
					  company-oddmuse
					  company-dabbrev
					  ))
  :config
  (add-hook 'css-mode-hook
            (lambda ()
              (set (make-local-variable 'company-backends) '(company-css))))
  (add-hook 'org-mode-hook
            (lambda ()
              (set (make-local-variable 'company-backends) '(company-tempo +/noweb-reference))))
  :general
  (company-active-map
   "<tab>" #'company-indent-or-complete-common))
;; :config ())  ; Show message if verbose is activated

(use-package hydra
  :config
	(defhydra hydra-zoom (:timeout 4)
	  "zoom"
	  ("l" text-scale-increase "in")
	  ("h" text-scale-decrease "out")
	  ("f" nil "finished" :exit t))

	(defhydra hydra-yank-pop ()
	  "yank"
	  ("C-y" yank nil)
	  ("M-y" yank-pop nil)
	  ("y" (yank-pop 1) "next")
	  ("Y" (yank-pop -1) "prev")
	  ("l" helm-show-kill-ring "list" :color blue))   ; or browse-kill-ring
  :general
	(my-leader-def
	  "z z" '(hydra-zoom/body :which-key "scale text")
	  "M-y" '(hydra-yank-pop/yank-pop :which-key "yank pop")
	  "C-y" '(hydra-yank-pop/yank :which-key "yank")))

(use-package rainbow-delimiters
  :ghook 'prog-mode-hook)

(use-package treemacs
  ;; :ghook ('(prog-mode-hook) #'treemacs)
  :custom
  (treemacs-display-in-side-window          nil)
  ;; (treemacs-expand-after-init               t)
  ;; (treemacs-position                        'left)
  ;; (treemacs-silent-filewatch                nil)
  ;; (treemacs-silent-refresh                  nil)
  ;; (treemacs-sorting                         'alphabetic-asc)
  ;; (treemacs-user-mode-line-format           "none")
  (treemacs-width                           28)
  :general
  ("M-0"   #'treemacs-select-window)
  (my-leader-def
	"0 0" #'treemacs
	"0 b" #'treemacs-bookmark
	"0 t" #'treemacs-find-tag
	"0 f" #'treemacs-find-file
	"0 d" #'treemacs-delete-other-windows))

;; (use-package ranger
;; :demand
;; :init (ranger-override-dired-mode t))
;; :init (setq ranger-override-dired t))
;; :custom 
;; (ranger-cleanup-on-disable t)
;; (ranger-excluded-extensions '("mkv" "iso" "mp4"))
;; (ranger-deer-show-details t)
;; (ranger-max-preview-size 10)
;; (ranger-show-literal nil)
;; (ranger-hide-cursor nil)

;(setq split-height-threshold nil)
;(setq split-width-threshold 0)

;(custom-set-variables
; '(ediff-window-setup-function 'ediff-setup-windows-plain)
; '(ediff-diff-options "-w")
; '(ediff-split-window-function 'split-window-horizontally))
;(add-hook 'ediff-after-quit-hook-internal 'winner-undo)

;(setq split-width-threshold (- (window-width) 10))
;(setq split-height-threshold nil)
;
;(defun count-visible-buffers (&optional frame)
;  "Count how many buffers are currently being shown. Defaults to selected frame."
;  (length (mapcar #'window-buffer (window-list frame))))
;
;(defun do-not-split-more-than-two-windows (window &optional horizontal)
;  (if (and horizontal (> (count-visible-buffers) 1))
;      nil
;    t))
;
;(advice-add 'window-splittable-p :before-while #'do-not-split-more-than-two-windows)

(use-package recentf
  :demand
  :custom
  (recentf-max-menu-items 25)
  :config
  (recentf-mode 1)
  (with-eval-after-load 'no-littering
    (add-to-list 'recentf-exclude no-littering-var-directory)
    (add-to-list 'recentf-exclude no-littering-etc-directory)))
  ;; :general
  ;; (my-leader-def 
    ;; "r" #'recentf-open-files))

(use-package org
  :straight (:type built-in)
  :preface
  (defun +/org-babel-tangle-config ()
    "Tangle an org file automatically after save if it is inside of user-emacs-directory variable"
    (let ((dir-conf (directory-file-name (expand-file-name user-emacs-directory)))
	  (dir-file (directory-file-name (file-name-directory (expand-file-name (buffer-file-name))))))
  (when (string-equal dir-conf dir-file)
	(let ((ext-conf (concat "org"))
	  (ext-file (file-name-extension (buffer-file-name))))
	  (when (string-equal ext-conf ext-file)
	    (let ((org-confirm-babel-evaluate nil))  ; Dynamic scoping to the rescue
	  (org-babel-tangle)))))))
  :gfhook
  #'(lambda () (add-hook 'after-save-hook #'+/org-babel-tangle-config))
  ;; #'variable-pitch-mode
  ;; #'auto-fill-mode ;; #'turn-on-auto-fill
  :config
  (setq org-hide-leading-stars t  ; Non-nil means hide the first N-1 stars in a headline
  	  org-image-actual-width 300
  	  org-src-fontify-natively t
  	  org-hide-emphasis-markers nil
        org-ellipsis " ↴")  ; The ellipsis to use in the Org mode outline (▾  ↴)
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
  		  :font "FiraCode Nerd Font"
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
  (setq org-odt-preferred-output-format "pdf")  ; Require LibreOffice (docx)
  (setq org-odt-category-map-alist
        '(("__Figure__" "Illustration" "value" "Figure" org-odt--enumerable-image-p)))
  (setq org-export-in-background t
  	  org-export-with-toc nil)
  (setq org-use-property-inheritance t)
  (setq org-startup-align-all-tables t  ; Non-nil means align all tables when visiting a file
  	  org-startup-truncated nil  ; Non-nil means entering Org mode will set truncate-lines
  	  org-startup-with-inline-images t
  	  org-startup-folded t  ; Non-nil means entering Org mode will switch to OVERVIEW
  	  org-hide-block-startup nil
  	  org-startup-indented nil)  ; Non-nil means turn on org-indent-mode on startup
  (setq org-cycle-separator-lines 2)
  (setq org-edit-src-content-indentation 0
  	  org-src-preserve-indentation nil)
  
  (with-eval-after-load 'org
    (require 'org-tempo)
    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
    (add-to-list 'org-structure-template-alist '("py" . "src python")))
  :custom
  (org-support-shift-select 'always)
  (org-export-backends '(ascii html icalendar latex man md odt org))
  :general
  (:states 'normal :keymaps 'org-mode-map
   "M-j" #'org-next-visible-heading
   "M-k" #'org-previous-visible-heading
   "C-j" #'org-metadown
   ;; "C-'" #'org-edit-special
   "C-k" #'org-metaup))
  ;; (my-leader-def
  ;;   "a" #'org-agenda
  ;;   "c" #'org-capture
  ;;   "l" #'org-store-link))

; Regular expression to match files for ‘org-agenda-files’
;(setq org-agenda-file-regexp )

; The files to be used for agenda display
;(setq org-agenda-files '("/media/files/Ricardo/Documents/Lists"))


; Information to record when a task moves to the DONE state
;(setq org-log-done 'time)    ; Add a time stamp to the task


; Non-nil means insert state change notes and time stamps into a drawer
;(setq org-log-into-drawer t)

; The initial value of log-mode in a newly created agenda window. More
(setq org-agenda-start-with-log-mode t)

(use-package org-superstar
  :after org
  :ghook 'org-mode-hook
  :custom
  (org-superstar-headline-bullets-list '("●" "◉" "○" "◉" "○"))
  :config ())  ; Show message if verbose is activated

(setq-default fill-column 80)

(use-package visual-fill-column
  :ghook 'org-mode-hook
  :custom
  (visual-fill-column-width 100)
  (visual-fill-column-center-text t)
  :config ())  ; Show message if verbose is activated

(use-package lorem-ipsum
  :custom
  (Lorem-ipsum-paragraph-separator “\n\n”)
  (Lorem-ipsum-sentence-separator “ “)
  (Lorem-ipsum-list-beginning “”)
  (Lorem-ipsum-list-bullet “* “)
  (Lorem-ipsum-list-item-end “\n”)
  (Lorem-ipsum-list-end “”)
  :general
  (my-leader-def
	"l i" '(:ignore t :which-key "Lorem Ipsum")
    "l i s" '(lorem-ipsum-insert-sentences :which-key "Sentence")
    "l i p" '(lorem-ipsum-insert-paragraphs :which-key "Paragraph")
    "l i l" '(lorem-ipsum-insert-list :which-key "List"))
  :config ())  ; Show message if verbose is activated

(use-package eshell
  :straight (:type built-in)
  :gfhook ('eshell-pre-command-hook #'eshell-save-some-history)
  :custom
  (eshell-history-size 8000)
  (eshell-buffer-maximum-lines 8000)
  (eshell-hist-ignoredups t)
  (eshell-scroll-to-bottom-on-input t)
  :config
  ; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)
  :general
  (my-leader-def
	"e s" '(eshell :which-key "Eshell")))

(use-package eshell-git-prompt
  :demand
  :after eshell
  :config
  (eshell-git-prompt-use-theme 'powerline))

;;Running programs in a term-mode buffer
;(with-eval-after-load 'esh-opt
;  (setq eshell-destroy-buffer-when-process-dies t)
;  (setq eshell-visual-commands '("htop" "zsh" "vim")))

;; (use-package shell
;;   :straight (:type built-in)
;;   :custom
;;   (comint-output-filter-functions
;;    (remove 'ansi-color-process-output comint-output-filter-functions)))

   ;In Windows if you like PowerShell you can use this config:
   ; Kudos to Jeffrey Snover: https://docs.microsoft.com/en-us/archive/blogs/dotnetinterop/run-powershell-as-a-shell-within-emacs
   ;(explicit-shell-file-name "powershell.exe")
   ;(explicit-powershell.exe-args '())

 ;  (add-hook 'shell-mode-hook
 ;      (lambda ()
 ;	;; Disable font-locking in this buffer to improve performance
 ;	(font-lock-mode -1)
 ;	;; Prevent font-locking from being re-enabled in this buffer
 ;	(make-local-variable 'font-lock-function)
 ;	(setq font-lock-function (lambda (_) nil))
 ;	(add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)))

 ; Better colors: https://github.com/atomontage/xterm-color

(use-package term
  :straight (:type built-in)
  :custom
  (term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (explicit-shell-file-name "zsh")
  (explicit-zsh-args '())
  :config ())  ; Show message if verbose is activated

(use-package eterm-256color
  :after term
  :ghook 'term-mode-hook
  :config ())  ; Show message if verbose is activated

(use-package vterm
  :straight (:type built-in)
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (setq vterm-shell "zsh")
  (setq vterm-max-scrollback 10000))

;(server-start)  ; Allow this Emacs process to be a server for client processes
;(setq show-value-server-raise-frame t)  ; If non-nil, raise frame when switching to a buffer
;(setq server-window (pop-to-buffer (current-buffer) t)) ; Specification of the window to use for selecting Emacs server buffers

(use-package magit
  :demand)
  ;; :commands (magit-status magit-get-current-branch magit-version))
  ;; :bind ("C-M-;" . magit-status)
  ;; :custom
  ;; (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  ;; :general
  ;; (my-leader-def
  ;;   "g"   '(:ignore t :which-key "git")
  ;;   "g s"  'magit-status
  ;;   "g d"  'magit-diff-unstaged
  ;;   "g c"  'magit-branch-or-checkout
  ;;   "g l"   '(:ignore t :which-key "log")
  ;;   "g l c" 'magit-log-current
  ;;   "g l f" 'magit-log-buffer-file
  ;;   "g b"  'magit-branch
  ;;   "g P"  'magit-push-current
  ;;   "g p"  'magit-pull-branch
  ;;   "g f"  'magit-fetch
  ;;   "g F"  'magit-fetch-all
  ;;   "g r"  'magit-rebase))

(use-package elfeed
  :custom
  (elfeed-search-filter "@3-days-ago")
  :general
  (my-leader-def
	"e f" #'elfeed)
  :config ())  ; Show message if verbose is activated

(use-package elfeed-org
  :demand
  :after elfeed
  :custom
  (rmh-elfeed-org-files (list "/media/files/Ricardo/Documents/Notes/rss.org"))
  :config ())  ; Show message if verbose is activated

(use-package erc
  :straight (:type built-in)
  :commands (erc erc-tls)
  :config
  (setq erc-server "irc.libera.chat"
		erc-nick "raisak"
		;; erc-user-full-name "Ricardo Gomez"
		erc-track-shorten-start 8
		erc-autojoin-channels-alist '(("irc.libera.chat" "#emacs" "#systemcrafters"))
		erc-kill-buffer-on-part t
        erc-auto-query 'bury))

(use-package cpp
  :straight (:type built-in)
  ;; :ghook 'c++-mode-hook
  :config
  (message "hello there!"))
;compile c++ whit f9
;(defun code-compile ()
;  (interactive)
;  (unless (file-exists-p "Makefile")
;    (set (make-local-variable 'compile-command)
;     (let ((file (file-name-nondirectory buffer-file-name)))
;       (format "%s -o %s %s"
;           (if  (equal (file-name-extension file) "cpp") "g++" "gcc" )
;           (file-name-sans-extension file)
;           file)))
;    (compile compile-command)))
;
;(global-set-key [f9] 'code-compile)

;; clang-format can be triggered using C-c C-f
;; Create clang-format file using google style
;; clang-format -style=google -dump-config > .clang-format
;; (require 'clang-format)
;; (global-set-key (kbd "C-c C-f") 'clang-format-region)

;; (require 'modern-cpp-font-lock)
;; (modern-c++-font-lock-global-mode t)

(use-package less-css-mode
  :straight (:type built-in)
  :config ())  ; Show message if verbose is activated

(use-package js
  :straight (:type built-in)
  :config ())  ; Show message if verbose is activated

(setq prettify-symbols-unprettify-at-point 'right-edge)

;; (use-package python
  ;; :straight (:type built-in)
  ;; :custom
  ;; (python-shell-interpreter "python")
  ;; (dap-python-executable "python3")
  ;; (dap-python-debugger 'debugpy)
  ;; :config ())  ; Show message if verbose is activated

(defun +sh--match-variables-in-quotes (limit)
  "Search for variables in double-quoted strings bounded by LIMIT."
  (with-syntax-table sh-mode-syntax-table
    (let (res)
      (while
          (and (setq res
                     (re-search-forward
                      "[^\\]\\(\\$\\)\\({.+?}\\|\\<[a-zA-Z0-9_]+\\|[@*#!]\\)"
                      limit t))
               (not (eq (nth 3 (syntax-ppss)) ?\"))))
      res)))

(defun +sh--match-command-subst-in-quotes (limit)
  "Search for variables in double-quoted strings bounded by LIMIT."
  (with-syntax-table sh-mode-syntax-table
    (let (res)
      (while
          (and (setq res
                     (re-search-forward "[^\\]\\(\\$(.+?)\\|`.+?`\\)"
                                        limit t))
               (not (eq (nth 3 (syntax-ppss)) ?\"))))
      res)))

(defvar +sh-builtin-keywords
  '("cat" "cd" "chmod" "chown" "cp" "curl" "date" "echo" "find" "git" "grep"
    "kill" "less" "ln" "ls" "make" "mkdir" "mv" "pgrep" "pkill" "pwd" "rm"
    "sleep" "sudo" "touch")
  "A list of common shell commands to be fontified especially in `sh-mode'.")

(use-package sh-script
  :straight (:type built-in)
  :mode ("\\.bats\\'" . sh-mode)
  :mode ("\\.\\(?:zunit\\|env\\)\\'" . sh-mode)
  :mode ("/bspwmrc\\'" . sh-mode)
  ;; :custom
  ;; (sh-indent-after-continuation 'always)
  :config
  ; Recognize function names with dashes in them
  (add-to-list 'sh-imenu-generic-expression
			   '(sh (nil "^\\s-*function\\s-+\\([[:alpha:]_-][[:alnum:]_-]*\\)\\s-*\\(?:()\\)?" 1)
					(nil "^\\s-*\\([[:alpha:]_-][[:alnum:]_-]*\\)\\s-*()" 1)))

  ;; 1. Fontifies variables in double quotes
  ;; 2. Fontify command substitution in double quotes
  ;; 3. Fontify built-in/common commands (see `+sh-builtin-keywords')
  (+/add-hook 'sh-mode-hook
	(defun +sh-init-extra-fontification-h ()
	  (font-lock-add-keywords
	   nil `((+sh--match-variables-in-quotes
			  (1 'font-lock-constant-face prepend)
			  (2 'font-lock-variable-name-face prepend))
			 (+sh--match-command-subst-in-quotes
			  (1 'sh-quoted-exec prepend))
			 (,(regexp-opt +sh-builtin-keywords 'symbols)
			  (0 'font-lock-type-face append)))))))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((html-mode
		  css-mode
		  js-mode
		  c++-mode
          sh-mode
		  python-mode
          gdscript-mode) . lsp-deferred)

         ; Which-key integration
         (lsp-mode . lsp-enable-which-key-integration)
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-modeline-diagnostics-scope :workspace)
  (lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-modeline-code-actions-segments '(count icon name))
  :config
  (lsp-headerline-breadcrumb-mode 1)
  (lsp-modeline-code-actions-mode 1))

(use-package dap-mode
  :after lsp-mode
  :config
  (dap-mode 1)

  ; UI
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (tooltip-mode 1)
  (dap-ui-controls-mode 1)


  ; C++
  ;; (require 'dap-gdb-lldb)
  ;; (dap-gdb-lldb-setup)

  ;Python
  ;; (require 'dap-python)
  
  ; Javascript
  (require 'dap-node)
  (dap-node-setup)

  (add-hook 'dap-stopped-hook
			(lambda (arg) (call-interactively #'dap-hydra)))

  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
  :keymaps 'lsp-mode-map
  :prefix lsp-keymap-prefix
  "d" '(dap-hydra t :wk "debugger")))

(use-package lsp-jedi
  :hook (python-mode . (lambda ()
                       (require 'lsp-jedi)
                       (lsp)))  ; or lsp-deferred
  :config
  (with-eval-after-load "lsp-mode"
    (add-to-list 'lsp-disabled-clients 'pyls)
    (add-to-list 'lsp-enabled-clients 'jedi)))

(use-package lsp-treemacs
  :after lsp-mode
  :commands lsp-treemacs-errors-list
  :config
  (lsp-treemacs-sync-mode 1))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-position 'top)
  (lsp-ui-doc-delay 0.6)
  :config ())  ; Show message if verbose is activated

(use-package projectile
  :demand
  :custom
  (projectile-discover-projects-in-search-path t)
  (projectile-project-search-path
   '("/media/files/Ricardo/Documents/Github" "/media/files/Ricardo/Projects"))
  :config
  (projectile-mode 1)
  :general
  (my-leader-def
	"p" 'projectile-command-map))

(use-package flycheck
  :init (global-flycheck-mode))
;; (add-hook 'after-init-hook #'global-flycheck-mode)

(use-package dashboard
  :hook (after-init . dashboard-refresh-buffer)
  :custom
  (dashboard-banner-logo-title "Welcome to Emacs!")
  (dashboard-center-content t)
  (dashboard-set-file-icons t)
  (dashboard-set-heading-icons t)
  (dashboard-show-shortcuts t)
  ;; (dashboard-startup-banner 'logo)
  (dashboard-startup-banner (expand-file-name "banner.txt" user-emacs-directory))
  (dashboard-items '((recents  . 5)
					 (bookmarks . 5)
					 (projects . 5)
					 ;; (agenda . 5)  ; This load org package
					 (registers . 5)))
  (dashboard-set-navigator t)
  (dashboard-navigator-buttons
   `(((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
	   "GitHub" "rgomezgerardi"
	   (lambda (&rest _) (browse-url "https://github.com/rgomezgerardi")))
	  (,(all-the-icons-faicon "linkedin" :height 1.1 :v-adjust 0.0)
	   "LinkedIn" "rgomezgerardi"
	   (lambda (&rest _) (browse-url "https://linkedin.com"))))))
  (dashboard-set-init-info t)
  (dashboard-init-info (+/display-startup-time))
  (dashboard-set-footer t)
  (dashboard-footer-messages
   '("Dashboard is pretty cool!"
	 "The one true editor, Emacs!"
	 "Who the hell uses VIM anyway? Go Evil!"
	 "Free as free speech, free as free Beer"
	 "Happy coding!"
	 "Vi Vi Vi, the editor of the beast"
	 "Go make yourself some friends, or you'll be lonely"
	 "Welcome to the church of Emacs"
	 "While any text editor can save your files, only Emacs can save your soul"
	 "What the fuck are you doing?"))
  :config
  ; Ensure emacsclient opens on *dashboard* rather than *scratch*
  (if (daemonp)
	  (setq initial-buffer-choice  
			(lambda () (get-buffer "*dashboard*")))))

; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
				prog-mode-hook
				conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

; Disable line numbers for some modes
(dolist (mode '(term-mode-hook
				dashboard-mode-hook
				org-mode-hook
				treemacs-mode-hook
				eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package consult
  :config
  ; Optionally configure a function which returns the project root directory.
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-root-function #'projectile-project-root)
  :general
  ("M-p" 'consult-yank-pop)
  (:states 'normal :keymaps 'org-mode-map
   "M-/" 'consult-org-heading)
  (isearch-mode-map
   "M-e" 'consult-isearch                 ;; orig. isearch-edit-string
   "M-s e" 'consult-isearch               ;; orig. isearch-edit-string
   "M-s l" 'consult-line                  ;; needed by consult-line to detect isearch
   "M-s L" 'consult-line-multi)           ;; needed by consult-line to detect isearch
  (my-leader-def
	":" 'consult-complex-command
	"@" 'consult-register
	"#" 'consult-register-load
	"'" 'consult-register-store

    "h a" 'consult-apropos
	
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

(use-package consult-lsp
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols))

(use-package marginalia
  :ghook 'pre-command-hook
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :general
  (minibuffer-local-map
   "C-a" #'marginalia-cycle)
  :config ())  ; Show message if verbose is activated

(use-package orderless
  :custom 
  (completion-category-defaults nil)
  (orderless-component-separator "[ &]")
  (completion-styles '(orderless))
  (completion-category-overrides '((file (styles . (orderless partial-completion)))))
  :config ())  ; Show message if verbose is activated
  ;; :config
  ;; ...otherwise find-file gets different highlighting than other commands
  ;; (set-face-attribute 'completions-first-difference nil :inherit nil)

  ;; (setq orderless-style-dispatchers '(lambda (pattern _index _total) 
  ;;   (cond
  ;;    ;; Ensure $ works with Consult commands, which add disambiguation suffixes
  ;;    ((string-suffix-p "$" pattern)
  ;; 	`(orderless-regexp . ,(concat (substring pattern 0 -1) "[\x100000-\x10FFFD]*$")))
  ;;    ;; Ignore single !
  ;;    ((string= "!" pattern) `(orderless-literal . ""))
  ;;    ;; Without literal
  ;;    ((string-prefix-p "!" pattern) `(orderless-without-literal . ,(substring pattern 1)))
  ;;    ;; Initialism matching
  ;;    ((string-prefix-p "`" pattern) `(orderless-initialism . ,(substring pattern 1)))
  ;;    ((string-suffix-p "`" pattern) `(orderless-initialism . ,(substring pattern 0 -1)))
  ;;    ;; Literal matching
  ;;    ((string-prefix-p "=" pattern) `(orderless-literal . ,(substring pattern 1)))
  ;;    ((string-suffix-p "=" pattern) `(orderless-literal . ,(substring pattern 0 -1)))
  ;;    ;; Flex matching
  ;;    ((string-prefix-p "~" pattern) `(orderless-flex . ,(substring pattern 1)))
  ;;    ((string-suffix-p "~" pattern) `(orderless-flex . ,(substring pattern 0 -1)))))))

(use-package savehist
  :demand
  :config
  (savehist-mode 1))

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

; Non-nil if Column-Number mode is enabled.
(setq column-number-mode t)

;; (defun +/set-font-faces ()
;;   (set-face-attribute 'default nil
;; 		  :font "FiraCode Nerd Font"
;; 		  :weight 'normal
;; 		  :height 120)

;;   (set-face-attribute 'fixed-pitch nil
;; 		  ;:family "Monospace"
;; 		  :font "FiraCode Nerd Font"
;; 		  ;:weight 'light
;; 		  :height 120)

;;   (set-face-attribute 'variable-pitch nil
;; 		  ;:family "Monospace"
;; 		  :font "Roboto"
;; 		  ;:weight 'light
;; 		  :height 120
		  ;; ))

; This is needed for the deamon (emacsclient)
;; (if (daemonp)
;; 	  (add-hook 'after-make-frame-functions ; (Emacs < 27)
;; 	  ;(add-hook 'server-after-make-frame-hook
;; 		(lambda (frame)
;; 		  (with-selected-frame frame
;; 			(+/set-font-faces))))
;; 	  (+/set-font-faces))

(use-package solaire-mode
  :ghook ('after-init-hook #'solaire-global-mode)
  :gfhook ('(dashboard-mode-hook) #'(lambda () (solaire-mode 0)))  ; Disable for some modes
  :config ())  ; Show message if verbose is activated

(setq doom-theme 'doom-one)

(use-package highlight-indent-guides
  :hook ((prog-mode
		  text-mode
		  conf-mode) . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-suppress-auto-error t)
  (highlight-indent-guides-character 9474)  ; | 124  ⇥ 8677  ⇨ 8680  ↦ 8614    default 9474
  (highlight-indent-guides-method 'character)  ; Method to use when displaying indent guides
  (highlight-indent-guides-responsive 'stack)
  (highlight-indent-guides-auto-enabled t)
;; Highlight Indent Guides Character Face
;; Foreground: #3e6a44a85124
;; Highlight Indent Guides Even Face
;; Background: #3e6a44a85124
;; Highlight Indent Guides Odd Face
;; Background: #3349386a42ac
;; Highlight Indent Guides Stack Character Face
;; Foreground: #54ad5d256e14
;; Highlight Indent Guides Stack Even Face
;; Background: #54ad5d256e14
;; Highlight Indent Guides Stack Odd Face
;; Background: #498c50e65f9c
;; Highlight Indent Guides Top Character Face
;; Foreground: #6af075a18b04
;; Highlight Indent Guides Top Even Face
;; Background: #6af075a18b04
;; Highlight Indent Guides Top Odd Face
;; Background: #5fce69637c8c
  :config
  (defun +indent-guides-init-faces-h (&rest _)
    (when (display-graphic-p)
      (highlight-indent-guides-auto-set-faces)))

  ;; HACK `highlight-indent-guides' calculates its faces from the current theme,
  ;;      but is unable to do so properly in terminal Emacs, where it only has
  ;;      access to 256 colors. So if the user uses a daemon we must wait for
  ;;      the first graphical frame to be available to do.
  (add-hook 'doom-load-theme-hook #'+indent-guides-init-faces-h)
  (when doom-theme
    (+indent-guides-init-faces-h))

  ;; `highlight-indent-guides' breaks when `org-indent-mode' is active
  (+/add-hook 'org-mode-local-vars-hook
    (defun +indent-guides-disable-maybe-h ()
      (and highlight-indent-guides-mode
           (bound-and-true-p org-indent-mode)
           (highlight-indent-guides-mode -1)))))

(global-prettify-symbols-mode 1)  ; Toggle Prettify-Symbols mode in all buffers
(setq prettify-symbols-alist '(("lambda" . 955)))

(use-package ligature
  :straight (ligature :type git :host github :repo "mickeynp/ligature.el")
  :ghook ('after-init-hook #'global-ligature-mode)
  :custom
  (ligature-ignored-major-modes '(minibuffer-inactive-mode dashboard-mode))
  (ligature-mode-set-explicitly t)
  :config
  (ligature-set-ligatures 't '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "\\\\"
                               ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                               "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                               "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                               "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                               "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                               "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                               "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                               ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                               "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                               "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "?:" "://"
                               "?=" "?." "??" ";;" "/*" "/=" "/>" "__" "~~" "(*" "*)" "||>"
							   ;; "++" "//"  ; Trouble maker
							   )))

(setq byte-compile-warnings '(cl-functions))  ; Disable "Package cl is deprecated" message

(use-package unicode-fonts
  :demand
  :config
  (unicode-fonts-setup))

(use-package rainbow-mode
  :ghook '(conf-mode-hook prog-mode-hook text-mode-hook)
  :config ())  ; Show message if verbose is activated

(use-package helpful
  :general
  (my-leader-def
	"h f" #'helpful-callable
	"h F" #'helpful-function
	"h o" #'helpful-symbol
	"h v" #'helpful-variable
	"h c" #'helpful-command
	"h i" #'info
	"h r" '(info-emacs-manual :which-key "Emacs Manual")
	"h O" '((lambda () (interactive) (info "org")) :which-key "Org Manual")
	"h R" '((lambda () (interactive) (info "elisp")) :which-key "Org Manual")
	"h k" #'helpful-key)
  :config ())  ; Show message if verbose is activated

(use-package which-key
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 0.4)
  :config ())  ; Show message if verbose is activated
