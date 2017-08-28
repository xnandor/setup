;;; package -- Sumary
;;; Commentary:
;;
;;  Emacs User Initialization File
;;  USER: ERIC BISCHOFF
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Code:

;;KEY SET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key "\M-a" 'next-buffer)
(global-set-key "\M-e" 'previous-buffer)
(global-set-key "\M-p" (lambda () (interactive) (forward-line -5)))
(global-set-key "\M-n" (lambda () (interactive) (forward-line 5)))
(global-set-key (kbd "C-x _") 'shrink-window)
(global-set-key (kbd "M-/") 'company-complete)
(global-set-key (kbd "<f8>") 'set-mark-command)
(global-set-key (kbd "M-h") 'company-irony-c-headers)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;CRONTAB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.cron\\(tab\\)?\\'" . crontab-mode))
(add-to-list 'auto-mode-alist '("cron\\(tab\\)?\\."    . crontab-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;SCRATCH
(setq initial-scratch-message "")
(setq inhibit-startup-message t)
;;VISUAL SETTINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq visible-bell 1)
(setq-default truncate-lines t)
(setq-default indent-tabs-mode nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-scrollbar-bg ((t (:background "yellow"))))
 '(company-scrollbar-fg ((t (:background "grey"))))
 '(company-tooltip ((t (:foreground "cyan" :weight bold))))
 '(company-tooltip-annotation ((t (:foreground "green"))))
 '(custom-face-tag ((t (:inherit custom-variable-tag))))
 '(font-lock-builtin-face ((t (:foreground "green" :weight bold))))
 '(font-lock-comment-face ((t (:foreground "red" :weight bold))))
 '(font-lock-constant-face ((t (:foreground "white"))))
 '(font-lock-function-name-face ((t (:foreground "#26C6DA" :weight bold))))
 '(font-lock-keyword-face ((t (:foreground "magenta" :weight bold))))
 '(font-lock-string-face ((t (:foreground "yellow" :weight bold))))
 '(font-lock-type-face ((t (:foreground "cyan" :weight bold))))
 '(font-lock-variable-name-face ((t (:foreground "white" :weight bold))))
 '(link ((t (:foreground "#ffff00" :underline t))))
 '(minibuffer-prompt ((t (:foreground "red" :weight bold))))
 '(my-carriage-return-face ((((class color)) (:background "blue"))) t)
 '(my-tab-face ((((class color)) (:background "grey20"))) t))
; add custom font locks to all buffers and all files
(add-hook
 'font-lock-mode-hook
 (function
  (lambda ()
    (setq
     font-lock-keywords
     (append
      font-lock-keywords
      '(
        ("\r" (0 'my-carriage-return-face t))
        ("\t" (0 'my-tab-face t))
        ))))))

; make characters after column 80 purple
(setq whitespace-style
  (quote (face trailing tab-mark lines-tail)))
;(add-hook 'find-file-hook 'whitespace-mode)

; transform literal tabs into a right-pointing triangle
;; (setq
;;  whitespace-display-mappings ;http://ergoemacs.org/emacs/whitespace-mode.html
;;  '(
;;    (tab-mark 9 [9654 9] [92 9])
;;    ;others substitutions...
;;    ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;ENABLE MODES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(fset 'yes-or-no-p 'y-or-n-p) ;Easy confirmation
(show-paren-mode 1) ;Parenthese Matching!
(column-number-mode 1) ;;changes display of position in info bar
(ido-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;DIRED
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kill-all-dired-buffers ()
  "Kill all dired buffers."
  (interactive)
  (save-excursion
    (let ((count 0))
      (dolist (buffer (buffer-list))
        (set-buffer buffer)
        (when (equal major-mode 'dired-mode)
          (setq count (1+ count))
          (kill-buffer buffer)))
      (message "Killed %i dired buffer(s)." count))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;END OF BUFFER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-mark-eob ()
   (let ((existing-overlays (overlays-in (point-max) (point-max)))
          (eob-mark (make-overlay (point-max) (point-max) nil t t))
           (eob-text "-----------------"))
     ;; Delete any previous EOB markers.  Necessary so that they don't
     ;; accumulate on calls to revert-buffer.
     (dolist (next-overlay existing-overlays)
       (if (overlay-get next-overlay 'eob-overlay)
              (delete-overlay next-overlay)))
     ;; Add a new EOB marker.
     (put-text-property 0 (length eob-text)
                        'face '(foreground-color . "slate gray") eob-text)
     (overlay-put eob-mark 'eob-overlay t)
     (overlay-put eob-mark 'after-string eob-text)))
(add-hook 'find-file-hooks 'my-mark-eob)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;CUSTOM FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun user-get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Add Marmalade To Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("e6h" . "http://www.e6h.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Kill Processes
;;
;; Since the next few sections deal with running code,
;; This makes it easier to terminate a process
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
;;   "Prevent annoying \"Active processes exist\" query when you quit Emacs."
;;   (flet ((process-list ())) ad-do-it))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;pbcopy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun user-pbcopy ()
  "Copies the current buffer to the pastboard."
  (interactive)
  (let ((Output
         (shell-command-to-string
          (concat
           "cat  ./"
           (buffer-name)
           " | pbcopy"
           ))))
    (progn (print "Buffer send to pastboard."))))
(global-set-key (kbd "M-c") 'next-buffer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;C Stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key "\C-c\C-m" 'compile)
(defun user-c-run ()
  "Proceedure for running c program from current buffer. 
 Requires clang.
 Without clang this function will not work without a make file.
 If clang is not a possibility it can always be rewritten to accept a different compiler."
  (interactive)
  (if (buffer-modified-p) (save-buffer))
  (if (file-exists-p "./Makefile") ;IF MAKEFILE EXIST
      (let (
            (EmacsBuildFromSrc (car (split-string (car (cdr (split-string (user-get-string-from-file "Makefile") ".*EMACS-BUILD-FROM-SRC *= *"))) "[\n]")))
            (EmacsRunFromSrc   (car (split-string (car (cdr (split-string (user-get-string-from-file "Makefile") ".*EMACS-RUN-FROM-SRC *= *")))   "[\n]"))))
        (let ((Output (shell-command-to-string EmacsBuildFromSrc)))
          (progn
            (print Output)
            (ansi-term EmacsRunFromSrc))))
    (if (file-exists-p "../Makefile") ;IF ../MAKEFILE EXIST
        (let (
              (EmacsBuildFromSrc (car (split-string (car (cdr (split-string (user-get-string-from-file "../Makefile") ".*EMACS-BUILD-FROM-SRC *= *"))) "[\n]")))
              (EmacsRunFromSrc   (car (split-string (car (cdr (split-string (user-get-string-from-file "../Makefile") ".*EMACS-RUN-FROM-SRC *= *")))   "[\n]"))))
          (let ((Output (shell-command-to-string EmacsBuildFromSrc)))
            (progn
              (print Output)
              (ansi-term EmacsRunFromSrc))))
      (let ((Output  ;IF NO MAKEFILE
             (progn 
               (shell-command-to-string 
                (concat 
                 "clang++ -std=c++11 -o "
                 (car (split-string (buffer-name) "\\."))
                 " "
                 (buffer-name)
                 )))))
        (if (<= (length Output) 3)
            (progn  ;SUCCESS
              (print "COMPILED SUCCESSFULLY")
              (sit-for 0.5)
              (print Output)
              (sit-for 0.5)
              (ansi-term 
               (concat "./" (car (split-string (buffer-name) "\\.")))))
          (progn  ;ERROR
            (print Output)))))))
(setq c-mode-map (make-sparse-keymap))
(define-key c-mode-map "\C-c\C-c" 'user-c-run)
(setq c++-mode-map (make-sparse-keymap))
(define-key c++-mode-map "\C-c\C-c" 'user-c-run)
(defun my-c++-mode-hook ()
  (setq c-basic-offset 2)
  (c-set-offset 'substatement-open 0)
  (global-company-mode)
  (global-flycheck-mode)
  )
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
;;(require 'cff)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;Java Stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun user-run-java-buffer ()
  "Proceedure previews the current latex document"
  (interactive)
  (if (buffer-modified-p) (save-buffer))
  (let ((Output
         (shell-command-to-string
          (concat
           "javac "
           (buffer-name)))))
    (if (<= (length Output) 2)
            (progn ;SUCCESS
              (shell-command (concat "java " (car (split-string (buffer-name) "\\.")))))
          (progn ;FAIL
            (print Output))))
)
(defun user-gradle-build ()
  ""
  (interactive)
  (gradle-build)
)
(defun user-gradle-run ()
  ""
  (interactive)
  (gradle-execute "run")
)
(defun user-gradle-ide ()
  ""
  (interactive)
  (gradle-execute "eclipse")
)
(defun user-gradle-test ()
  ""
  (interactive)
  (gradle-execute "test")
)
(defun user-gradle-spring ()
  ""
  (interactive)
  (gradle-execute "bootRun")
)
(defun user-gradle-clean ()
  ""
  (interactive)
  (gradle-execute "clean")
)
(defun user-gradle-quit ()
  ""
  (interactive)
  (kill-buffer "*compilation*")
  (delete-other-windows)
  
)
(defun user-file-search-upward (directory file)
  "Search DIRECTORY for FILE and return its full path if found, or NIL if not. If FILE is not found in DIRECTORY, the parent of DIRECTORY will be searched."
  (interactive)
  (let ((parent-dir (file-truename (concat (file-name-directory directory) "../")))
        (current-path (if (not (string= (substring directory (- (length directory) 1)) "/"))
                         (concat directory "/" file)
                         (concat directory file))))
    (if (file-exists-p current-path)
        current-path
        (when (and (not (string= (file-truename directory) parent-dir))
                   (< (length parent-dir) (length (file-truename directory))))
          (user-file-search-upward parent-dir file)))))
(defun user-find-gradle-file ()
  "Uses helm to find a pattern stopping at the gradle root directory."
  (interactive)
  (if (string= (file-name-nondirectory buffer-file-name) "build.gradle")
      (helm-find nil)
      (let ((Path (file-name-directory (user-file-search-upward (buffer-file-name) "build.gradle"))))
        (if (stringp Path)
            (progn ;; Found it.
              (let ((default-directory Path))
                                        ;(print default-directory)
                (helm-find nil)
                )
              )(progn ;; False
                 (print "Couldn't find build.gradle.")
                 )))))
(add-hook 'java-mode-hook
            '(lambda ()
               (local-set-key "\C-c\C-c" 'user-gradle-build)
               (local-set-key "\C-c\C-r" 'user-gradle-run)
               (local-set-key "\C-c\C-i" 'user-gradle-ide)
               (local-set-key "\C-c\C-s" 'user-gradle-spring)
               (local-set-key "\C-c\C-t" 'user-gradle-test)
               (local-set-key "\C-c\C-k" 'user-gradle-clean)
               (local-set-key "\C-c\C-q" 'user-gradle-quit)
               (local-set-key "\C-x\C-d" 'eclim-java-find-declaration)
               (local-set-key "\C-x\C-r" 'eclim-java-find-references)
               (local-set-key "\C-c\C-f" 'eclim-problems-correct)
               (local-set-key "\C-c\C-o" 'eclim-java-import-organize)
               ;;Helm
               (require 'helm-mode)
               (set-face-attribute 'helm-selection nil 
                                   :background "black"
                                   :foreground "yellow")
               (groovy-electric-mode)
               (local-set-key "\C-x\C-g" 'user-find-gradle-file)
               ;;Eclim
               (gradle-mode 1)
               (require 'company)
               (require 'eclim)
               (require 'eclimd)
               (require 'company-eclim)
               (require 'yasnippet)
               (global-eclim-mode t)
               (global-company-mode)
               (eclim-mode)
               (custom-set-variables
                '(eclim-eclipse-dirs '("/Applications/Eclipse.app/Contents/Eclipse/"))
                '(eclim-executable "/Applications/Eclipse.app/Contents/Eclipse/eclim")
                '(eclimd-default-workspace "/Users/ebischoff/code/java/")
                '(eclimd-wait-for-process t)
                )
               (setq help-at-pt-display-when-idle t)
               (setq help-at-pt-timer-delay 0.1)
               (help-at-pt-set-timer)
               (yas-global-mode 1)
               (start-eclimd)
               
               ))

(add-hook 'groovy-mode-hook '(lambda ()
             (require 'helm-mode)
             (require 'groovy-electric)
             (set-face-attribute 'helm-selection nil 
                    :background "black"
                    :foreground "yellow")
             (groovy-electric-mode)
             (local-set-key "\C-x\C-g" 'user-find-gradle-file)
             (gradle-mode 1)
             (local-set-key "\C-c\C-c" 'user-gradle-build)
             (local-set-key "\C-c\C-r" 'user-gradle-run)
             (local-set-key "\C-c\C-i" 'user-gradle-ide)
             (local-set-key "\C-c\C-s" 'user-gradle-spring)
             (local-set-key "\C-c\C-t" 'user-gradle-test)
             (local-set-key "\C-c\C-k" 'user-gradle-clean)
             (local-set-key "\C-c\C-q" 'user-gradle-quit)
))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;PROLOG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'prolog-mode "prolog.el" "A Major Mode for editing prolog files." t)
(setq auto-mode-alist (append (list (cons "\\.pl\\'" 'prolog-mode)) auto-mode-alist))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;SEARCH ALL BUFFERS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;I know that string is in my Emacs somewhere!
(require 'cl)
(defcustom search-all-buffers-ignored-files (list (rx-to-string '(and bos (or ".bash_history" "TAGS") eos)))
  "Files to ignore when searching buffers via \\[search-all-buffers]."
  :type 'editable-list)

(require 'grep)
(defun user-search-all-buffers (regexp prefix)
  "Searches file-visiting buffers for occurence of REGEXP.  With
prefix > 1 (i.e., if you type C-u \\[search-all-buffers]),
searches all buffers."
  (interactive (list (grep-read-regexp)
                     current-prefix-arg))
  (message "Regexp is %s; prefix is %s" regexp prefix)
  (multi-occur
   (if (member prefix '(4 (4)))
       (buffer-list)
     (remove-if
      (lambda (b) (some (lambda (rx) (string-match rx  (file-name-nondirectory (buffer-file-name b)))) search-all-buffers-ignored-files))
      (remove-if-not 'buffer-file-name (buffer-list))))
   regexp))
(global-set-key "\M-s" 'user-search-all-buffers)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;WEB TOOLS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar hexcolour-keywords
  '(("#[abcdef[:digit:]]\\{6\\}"
     (0 (put-text-property
         (match-beginning 0)
         (match-end 0)
         'face (list :background
                     (match-string-no-properties 0)))))))
(defun hexcolour-add-to-font-lock ()
  (font-lock-add-keywords nil hexcolour-keywords))

(add-hook 'css-mode-hook 'hexcolour-add-to-font-lock)
(add-hook 'php-mode-hook 'hexcolour-add-to-font-lock)
(add-hook 'html-mode-hook 'hexcolour-add-to-font-lock)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;FACE TOOLS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun face-which-custom (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;ENABLE MOUSE USE WITH "MOUSE TERM" AND "SMBL"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
  (xterm-mouse-mode 1)
  (global-set-key [mouse-4] '(lambda ()
                                                           (interactive)
                                                           (deactivate-mark)))
  (global-set-key [mouse-5] '(lambda ()
                                                           (interactive)
                                                           (deactivate-mark)))
  (global-set-key [mouse-4] '(lambda ()
                                                           (interactive)
                                                           (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                                                           (interactive)
                                                           (scroll-up 1)))
  (defun track-mouse (e))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;FILE BACKUP AND RECOVERY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eclim-eclipse-dirs (quote ("/Applications/Eclipse.app/Contents/Eclipse/")))
 '(eclim-executable "/Applications/Eclipse.app/Contents/Eclipse/eclim")
 '(eclimd-default-workspace "/Users/ebischoff/code/java/")
 '(eclimd-wait-for-process t)
 '(package-selected-packages
   (quote
    (crappy-jsp-mode helm find-file-in-project groovy-mode gradle-mode java-imports eclim cff ripgrep popup irony flycheck-clang-tidy f company-rtags company-c-headers ag))))
