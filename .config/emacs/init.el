(setq
 skip-dirs nil
 boot-order '("straight"
	      "use-package"
	      "gcmh"
	      "exec-path-from-shell"
	      "no-littering"
	      "general"
	      "doom-themes"
 ))

(mapc
 (lambda (package)
   (load-file (expand-file-name (concat (mapconcat 'identity (directory-files-recursively user-emacs-directory package t) nil) "/config")))
   (add-to-list 'skip-dirs package))
 boot-order)

(mapc
 (lambda (x) (load-file x))
 (seq-filter
  (lambda (path)
    (not (seq-some
          (lambda (dir) (string-match dir path))
          skip-dirs )))
  (directory-files-recursively user-emacs-directory "^config$" )))
