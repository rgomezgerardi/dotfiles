(setq auto-save-interval 500)

(setq make-backup-files nil)  ; Non-nil means make a backup of a file the first time it is saved.

(menu-bar-mode 0)  ; Toggle display of a menu bar on each frame
(scroll-bar-mode 0)  ; Toggle vertical scroll bars on all frames
(tool-bar-mode 0)  ; Toggle the tool bar in all graphical frames
; Alist of default values for frame creation
(set-frame-parameter (selected-frame) 'alpha '(100 . 100))
     (add-to-list 'default-frame-alist '(alpha . (100 . 100)))

; Default appearance of fringes on all frames.
(setq set-fringe-mode 10)        ; Give some breathing room

(setq inhibit-startup-echo-area-message t
	  ;; inhibit-startup-screen t
	  user-emacs-directory-warning t)

; Buffer to show after starting Emacs
(if (daemonp)  ; This is needed for emacsclient
	(setq initial-buffer-choice
		  (lambda () (get-buffer "*Messages*"))))

; Disable startup echo area message
(put 'inhibit-startup-echo-area-message 'saved-value t)
(setq inhibit-startup-echo-area-message (user-login-name))
;(fset 'display-startup-echo-area-message 'ignore)

;; (add-hook 'emacs-startup-hook #'+/display-startup-time)
