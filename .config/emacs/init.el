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
  ;; :gfhook ('(org-mode-hook
	     ;; dashboard-mode-hook) #'(lambda () (vi-tilde-fringe-mode 0)))  ; Disable for some modes
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

(use-package company
  ;; :preface
  ;; (defun +/noweb-reference (command &optional arg &rest ignored)
  ;; 	"Complete `<<' with the names of defined SRC blocks."
  ;; 	(interactive (list 'interactive))
  ;; 	(cl-case command
  ;;     (interactive (company-begin-backend '+/noweb-reference))
  ;;     (init (require 'org-element))
  ;;     (prefix (and (eq major-mode 'org-mode)
  ;; 				   (eq 'src-block (car (org-element-at-point)))
  ;; 				   (cons (company-grab-line "^<<\\(\\w*\\)" 1) t)))
  ;;     (candidates
  ;;      (org-element-map (org-element-parse-buffer) 'src-block
  ;; 		 (lambda (src-block)
  ;; 		   (let ((name (org-element-property :name src-block)))
  ;; 			 (when name
  ;; 			   (propertize
  ;; 				name
  ;; 				:value (org-element-property :value src-block)
  ;; 				:annotation (org-element-property :raw-value (org-element-lineage src-block '(headline)))))))))
  ;;     (sorted t)            ; Show candidates in same order as doc
  ;;     (ignore-case t)
  ;;     (duplicates nil)               ; No need to remove duplicates
  ;;     (post-completion               ; Close the reference with ">>"
  ;;      (insert ">>"))
  ;;     ;; Show the contents of the block in a doc-buffer. If you have
  ;;     ;; company-quickhelp-mode enabled it will show in a popup
  ;;     (doc-buffer (company-doc-buffer (get-text-property 0 :value arg)))
  ;;     (annotation (format " [%s]" (get-text-property 0 :annotation arg)))))
  ;; :hook (after-init . global-company-mode)
  :demand
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.1)
  ;; (company-backends '(company-bbdb
  ;; 		      company-semantic
  ;; 		      company-cmake
  ;; 		      company-capf
  ;; 		      ;; company-clang
  ;; 		      company-files
  ;; 		      (company-dabbrev-code company-gtags company-etags company-keywords)
  ;; 		      company-oddmuse
  ;; 		      company-dabbrev
  ;; 		      company-tempo
  ;; 		      company-yasnippet
  ;; 		      ))
  :config
  (global-company-mode 1)
  ;; (add-to-list company-backends ')
  ;; (add-hook 'css-mode-hook
            ;; (lambda ()
              ;; (set (make-local-variable 'company-backends) '(company-css))))
  ;; (add-hook 'org-mode-hook
  ;;           (lambda ()
  ;;             (set (make-local-variable 'company-backends) '(company-tempo +/noweb-reference))))
  :general
  (company-active-map
   "<tab>" #'company-indent-or-complete-common)
)

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

(use-package files :straight (:type built-in)
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
  ; Smooth Scroll
  ;; (scroll-step 1)
  ;; (redisplay-dont-pause nil)
  ;; (scroll-margin 3)
  ;; (scroll-conservatively 10000)
  ;; (scroll-preserve-screen-position 1)
  ;; (scroll-margin 1)
  ;; (scroll-conservatively 0)
  ;; (scroll-up-aggressively 0.01)
  ;; (scroll-down-aggressively 0.01)
  ;; (auto-window-vscroll t) ;;      scroll-down-aggressively 0.01
  ;; (kept-old-versions 0)
  :config
  (fset 'save-buffers-kill-emacs '+/save-buffers-kill-emacs)
  :general
  (leader-def
    "f" '(:ignore t :which-key "file")
    "f f" #'(find-file :wk "find")
    "f c" #'((lambda () (interactive) (find-file "~/.config/emacs/README.org")) :wk "config")
    "e r" #'((lambda () (interactive) (load-file "~/.config/emacs/init.el")) :wk "reload emacs config")
    "e k" #'(kill-emacs :wk "kill emacs")
    "b k" #'(kill-current-buffer :wk "kill current buffer")
    "b K" #'(kill-buffer :wk "kill buffer")
    "b n" #'(next-buffer :wk "next buffer")
    "b p" #'(previous-buffer :wk "previous buffer")
    "t t" #'(toggle-truncate-lines :wk "toggle truncate lines")
))

(use-package autorevert :straight (:type built-in)
  :demand
  :custom
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
  org-agenda-files "/home/user/.config/emacs/agenda-files"
  org-agenda-file-regexp "\\`[^.].*\\(\\.org\\)?\\'"
  )
  (setq org-agenda-start-with-log-mode t)
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
   )
  
  ;; (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (setq org-use-property-inheritance t)
  (setq
  org-log-done 'time
  org-log-into-drawer t
  org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)"))
  	  ;; (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")
  )
  
  ; Refile
  (setq org-refile-targets '((nil :maxlevel . 1)
                             (org-agenda-files :maxlevel . 1)))
  
  ; (setq org-refile-targets
        ;; '(("Archive.org" :maxlevel . 1)))
  
  (advice-add 'org-refile :after 'org-save-all-org-buffers)  ; Save Org buffers after refiling!
  
  
  ; Templates
  (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "/mnt/files/Ricardo/Documents/notes/task.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
      ;; ("ts" "Clocked Entry Subtask" entry (clock)
      ;;      "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
  
      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "/mnt/files/Ricardo/Documents/notes/journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "/mnt/files/Ricardo/Documents/notes/journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)
  
      ;; ("w" "Workflows")
      ;; ("we" "Checking Email" entry (file+olp+datetree ,(dw/get-todays-journal-file-name))
      ;;      "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)
  
      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "/mnt/files/Ricardo/Documents/notes/metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))
  
  ;; (define-key global-map (kbd "C-c j")
  ;;   (lambda () (interactive) (org-capture nil "j")))
  
  ;; (require 'org-habit)
  ;; (add-to-list 'org-modules 'org-habit)
  ;; (setq org-habit-graph-column 60)
  
   ;; Configure custom agenda views
  (setq org-agenda-custom-commands
    '(("d" "Dashboard"
       ((agenda "" ((org-deadline-warning-days 7)))
        (todo "NEXT"
          ((org-agenda-overriding-header "Next Tasks")))
        (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))
  
      ("n" "Next Tasks"
       ((todo "NEXT"
          ((org-agenda-overriding-header "Next Tasks")))))
  
  
      ("W" "Work Tasks" tags-todo "+work")
  
      ;; Low-effort next actions
      ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
       ((org-agenda-overriding-header "Low Effort Tasks")
        (org-agenda-max-todos 20)
        (org-agenda-files org-agenda-files)))
  
      ("w" "Workflow Status"
       ((todo "WAIT"
              ((org-agenda-overriding-header "Waiting on External")
               (org-agenda-files org-agenda-files)))
        (todo "REVIEW"
              ((org-agenda-overriding-header "In Review")
               (org-agenda-files org-agenda-files)))
        (todo "PLAN"
              ((org-agenda-overriding-header "In Planning")
               (org-agenda-todo-list-sublevels nil)
               (org-agenda-files org-agenda-files)))
        (todo "BACKLOG"
              ((org-agenda-overriding-header "Project Backlog")
               (org-agenda-todo-list-sublevels nil)
               (org-agenda-files org-agenda-files)))
        (todo "READY"
              ((org-agenda-overriding-header "Ready for Work")
               (org-agenda-files org-agenda-files)))
        (todo "ACTIVE"
              ((org-agenda-overriding-header "Active Projects")
               (org-agenda-files org-agenda-files)))
        (todo "COMPLETED"
              ((org-agenda-overriding-header "Completed Projects")
               (org-agenda-files org-agenda-files)))
        (todo "CANC"
              ((org-agenda-overriding-header "Cancelled Projects")
               (org-agenda-files org-agenda-files)))))))
  (setq
  org-startup-align-all-tables t  ; Non-nil means align all tables when visiting a file
  org-startup-truncated nil  ; Non-nil means entering Org mode will set truncate-lines
  org-startup-with-inline-images t
  org-startup-folded t  ; Non-nil means entering Org mode will switch to OVERVIEW
  org-hide-block-startup nil
  org-startup-indented nil  ; Non-nil means turn on org-indent-mode on startup
  )  
  ;; (setq system-time-locale "C") 
  :custom
  (org-support-shift-select 'always)
  (org-modules '(ol-w3m ol-bbdb ol-bibtex ol-docview ol-gnus ol-info ol-irc ol-eww
		 org-habit org-bookmark org-eshell org-tempo org-toc))
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
    "o a" #'(org-agenda :wk "agenda")
    "o c" #'(org-capture :wk "capture")
    "o ;" #'(org-toggle-comment :wk "toggle comment")
    "o :" #'(org-toggle-link-display :wk "toggle link display")
    "o t" #'(org-todo :wk "todo")

    "o l" #'(org-store-link :wk "store link")))

(use-package org-superstar
  :after org
  :ghook 'org-mode-hook
  :custom
  (org-superstar-headline-bullets-list '("●" "◉" "○" "◉" "○"))
  :config ())  ; Show message if verbose is activated

(use-package visual-fill-column
  :hook (visual-line-mode . visual-fill-column-mode)
  :custom
  (visual-fill-column-width 120)
  (visual-fill-column-center-text t)
  :config ())  ; Show message if verbose is activated

(use-package saveplace
  :straight (:type built-in)
  :demand
  :config
  (save-place-mode 1))

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
)

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
  :after doom-themes
  :demand
  :hook ((message-mode dashboard-mode) . (lambda () (solaire-mode 0)))
  ;; :gfhook ('(dashboard-mode-hook) #'(lambda () (solaire-mode 0)))  ; Disable for some modes
  :config (solaire-global-mode t))

(use-package customize :straight (:type built-in)
  :custom
  (custom-file (locate-user-emacs-file "custom-vars.el"))
  :config
  (load custom-file 'noerror 'nomessage))

(use-package helpful
  :general
  (leader-def
    "h" '(:ignore t :which-key "help")
    "h f" #'(helpful-callable :wk "callable")
    "h F" #'(helpful-function :wk "function")
    "h o" #'(helpful-symbol :wk "symbol")
    "h v" #'(helpful-variable :wk "variable")
    "h c" #'(helpful-command :wk "command")
    "h i" #'(info :wk "info")
    "h k" #'(helpful-key :wk "key")
    "h r" #'(info-emacs-manual :wk "emacs manual")
    "h a" #'(consult-apropos :wk "apropos")
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
