; Prevent Emacs from asking "modified buffers exist; exit anyway?"
(defun +/my-save-buffers-kill-emacs (&optional arg)
  "Offer to save each buffer(once only), then kill this Emacs process.
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
(fset 'save-buffers-kill-emacs '+/my-save-buffers-kill-emacs)

; Smooth Scroll
(setq 
 ;; redisplay-dont-pause nil
	  ;; scroll-margin 3
	  scroll-step 1)
	  ;; scroll-conservatively 10000
	  ;; scroll-preserve-screen-position 1)

 ;; (setq scroll-margin 1
 ;;      scroll-conservatively 0
 ;;      scroll-up-aggressively 0.01
 ;;      scroll-down-aggressively 0.01)
 ;;    (setq-default scroll-up-aggressively 0.01
 ;; (setq scroll-conservatively 10000)
    ;; (setq auto-window-vscroll nil);;      scroll-down-aggressively 0.01)

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
