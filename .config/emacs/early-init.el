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

(use-package exec-path-from-shell
  :demand
  :custom
  (exec-path-from-shell-arguments '("-l"))
  :config
  ;  gnu/linux Linux |  windows-nt Windows | darwin macOS
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
   auto-save-list-file-name `((".*" ,(no-littering-expand-var-file-name "auto-save-list") t))
   ;; url-history-file (expand-file-name "data/url/history" user-emacs-directory)))
   url-history-file (no-littering-expand-var-file-name "url/history")))

(use-package general
  :demand
  :defines texinfo-section-list
  :config
  ;; (general-auto-unbind-keys)  ; Automatic Key Unbinding
  (general-setq auto-revert-interval 10)

  (defconst leader "SPC")
  (general-create-definer leader-def
    :states '(motion normal insert emacs)
    :keymaps 'override
    :prefix leader
    :non-normal-prefix (concat "M-" leader)
    :prefix-command 'leader-prefix-command
    :prefix-map 'leader-prefix-map)
  
  (general-def "<escape>" #'keyboard-escape-quit))

(use-package doom-themes
  :demand
  :custom
  ;; (doom-theme 'doom-one)  ; This is for highlight indent guide
  (doom-themes-enable-bold t)  ; If nil, bold will be disabled across all faces
  (doom-themes-enable-italic t)  ; If nil, italics will be disabled across all faces
  (doom-themes-padded-modeline nil)  ; Default value for padded-modeline setting for themes that support it
  (doom-themes-treemacs-theme "doom-atom")
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)  ; Enable flashing the mode-line on error
  (doom-themes-treemacs-config)  ; Install doom-themes' treemacs configuration
  (doom-themes-org-config))  ; Corrects (and improves) org-mode's native fontification

; Alist of default values for frame creation
;; (set-frame-parameter (selected-frame) 'alpha '(100 . 100))
	;; (add-to-list 'default-frame-alist '(alpha . (100 . 100)))

(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)

(setq 
inhibit-startup-message t
inhibit-startup-echo-area-message t
inhibit-startup-screen t
user-emacs-directory-warning t
initial-buffer-choice (lambda () (get-buffer "*Messages*"))  ; Buffer to show after starting Emacs
)

; Disable startup echo area message
(fset 'display-startup-echo-area-message 'ignore)
