;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; other configuration examples
;; https://github.com/hlissner/doom-emacs-private
;; https://github.com/zaiste/.doom.d/blob/master/init.el
;;

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Tony Day"
      user-mail-address "tonyday567@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Iosevka ss02" :size 14 :weight 'light)
      doom-variable-pitch-font (font-spec :family "Iosevka etoile" :size 20))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-Iosvkem)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; global settings
;; FIXME: Should global settings (and doom standard package ones) go in (after! emacs :config)
;;
;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))

(setq evil-split-window-below t
      evil-vsplit-window-right t
      confirm-kill-emacs nil
      shift-select-mode nil
      window-combination-resize t)

;; setq-default sets variables that are usually local to buffers
(setq-default truncate-lines nil)

;; lsp settings
(global-so-long-mode -1)
(setq lsp-modeline-diagnostics-scope :project)
(setq lsp-modeline-code-actions-segments '(count icon))
(setq vertico-sort-function #'vertico-sort-history-alpha)

;; tidal
;;
;; latest start.scd for SC
;;
;; Server.local.options.sampleRate = 44100;
;; SuperDirt.start;
;; s.reboot
(use-package! tidal
    :init
    (progn
      ;; (setq tidal-interpreter "ghci")
      ;; (setq tidal-interpreter-arguments (list "ghci" "-XOverloadedStrings" "-package" "tidal"))
      ;; (setq tidal-boot-script-path "~/.emacs.doom/.local/straight/repos/Tidal/BootTidal.hs")
      ))

;; deft configuration
;;
;;
(after! deft
  (setq
   deft-directory "~/org/notes"
   deft-extensions '("org" "txt" "md")
   deft-recursive t
   deft-file-naming-rules
   (quote
    ((noslash . "-")
     (nospace . "-")
     (case-fn . downcase)))
   deft-strip-summary-regexp "\\([
	]\\|^#\\+.+:.*$\\)"
   delete-by-moving-to-trash nil
   ))

;; org
;;

(after! org
  (setq
   org-capture-templates
   (quote
    (("r" "refile" entry
      (file "~/org/refile.org")
      "* ToDo %?
")
     ("z" "bugz" entry
      (file+headline "~/org/bugz.org" "bugz!")
      "* ToDo %?
%a"))))
  (setq
   ;; FIXME: this is not needed???
   org-babel-load-languages
   '((emacs-lisp . t)
     (zsh . t)
     (haskell . t))
   org-superstar-headline-bullets-list '("⁖")
   org-startup-folded 'overview
   org-support-shift-select t
   org-startup-folded t
   org-insert-heading-respect-content nil)

  ;; flyspell off for org mode
  (remove-hook 'org-mode-hook 'flyspell-mode)
  (map! :leader "r" #'org-random)
  (add-hook 'org-babel-after-execute-hook #'display-ansi-colors))

(after! org
  :config
   (setq-default org-todo-keywords '((sequence "ToDo(t)" "Next(n)" "Blocked(b@)" "|" "Done(d!)")))
   (setq org-todo-keyword-faces (quote (("ToDo" :foreground "#2E2E8B8B5757" :weight bold)
                                        ("Done" :foreground "black" :weight bold)
                                        ("Blocked" :foreground "yellow4" :weight bold)
                                        ("Next" :foreground "orange red" :weight bold))))
   (setq org-agenda-category-icon-alist
        `(("life" ,(list (all-the-icons-material "home" :height 1)) nil nil :ascent center)
          ("sys" ,(list (all-the-icons-material "settings" :height 1)) nil nil :ascent center)
          ("bugz" ,(list (all-the-icons-material "flag" :height 1)) nil nil :ascent center)
          ("emacs" ,(list (all-the-icons-material "edit" :height 1)) nil nil :ascent center)
          ("repo" ,(list (all-the-icons-material "ac_unit" :height 1)) nil nil :ascent center)
          ("ib" ,(list (all-the-icons-material "account_balance" :height 1)) nil nil :ascent center)
          ("fe" ,(list (all-the-icons-material "local_atm" :height 1)) nil nil :ascent center)
          ("drafts" ,(list (all-the-icons-material "format_align_left" :height 1)) nil nil :ascent center)
          ("iqfeed" ,(list (all-the-icons-material "account_balance" :height 1)) nil nil :ascent center)
          ("haskell" ,(list (all-the-icons-material "event_available" :height 1)) nil nil :ascent center)
          ("refile" ,(list (all-the-icons-material "move_to_inbox" :height 1)) nil nil :ascent center)))
)

(defun org-random (&optional arg)
  "Select and goto a random todo item from the global agenda"
  (interactive "P")
  (require 'org-agenda)
  (if (and (stringp arg) (not (string-match "\\S-" arg))) (setq arg nil))
  (let* ((today (org-today))
         (date (calendar-gregorian-from-absolute today))
         (kwds org-todo-keywords-for-agenda)
         (lucky-entry nil)
         (completion-ignore-case t)
         (org-select-this-todo-keyword
          (if (stringp arg) arg
            (and arg (integerp arg) (> arg 0)
                 (nth (1- arg) kwds))))
         rtn rtnall files file pos marker buffer)
    (when (equal arg '(4))
      (setq org-select-this-todo-keyword
            (org-icompleting-read "Keyword (or KWD1|K2D2|...): "
                                 (mapcar 'list kwds) nil nil)))
    (and (equal 0 arg) (setq org-select-this-todo-keyword nil))
    (catch 'exit
      (setq files (org-agenda-files)
            rtnall nil)
      (while (setq file (pop files))
        (catch 'nextfile
          (org-check-agenda-file file)
          (setq rtn (org-agenda-get-day-entries file date :todo))
          (setq rtnall (append rtnall rtn))))

      (when rtnall
        (setq lucky-entry
              (nth (random
                    (safe-length
                     (setq entries rtnall)))
                   entries))

        (setq marker (or (get-text-property 0 'org-marker lucky-entry)
                         (org-agenda-error)))
        (setq buffer (marker-buffer marker))
        (setq pos (marker-position marker))
        (org-pop-to-buffer-same-window buffer)
        (widen)
        (goto-char pos)
        (when (derived-mode-p 'org-mode)
          (org-show-context 'agenda)
          (save-excursion
            (and (outline-next-heading)
                 (org-flag-heading nil))) ; show the next heading
          (when (outline-invisible-p)
            (show-entry))               ; display invisible text
          (run-hooks 'org-agenda-after-show-hook))))))

(after! org-agenda
  :config
  (setq org-agenda-span 'week
        org-agenda-use-time-grid nil
        org-agenda-start-day "-0d"
        org-agenda-files '("~/org" "~/org/notes")
        org-agenda-block-separator nil
        org-agenda-compact-blocks t
        org-agenda-show-all-dates nil
        org-agenda-prefix-format
         '((agenda . " %i %-12t")
           (todo . " %i %-12:c")
           (tags . " %i %-12:c")
           (search . " %i %-12:c"))))

(after! org-agenda
  :config
    (add-to-list 'org-modules 'org-habit)
    (require 'org-habit)
    (setq org-habit-graph-column 32)
    (setq org-habit-following-days 2)
    (setq org-habit-preceding-days 20)
    (setq org-log-into-drawer t)
 )

(defun agenda-z ()
  (interactive)
  (org-agenda nil "z"))

(map! :leader "oz" #'agenda-z)

(use-package! alert)

;; FIXME: not turning on
(use-package! org-wild-notifier
  :defer t
  :config
  (add-hook! 'after-init-hook 'org-wild-notifier-mode)
  (setq ;;org-wild-notifier-alert-time 15
        alert-default-style (if IS-MAC 'osx-notifier 'libnotify)))

(defun make-qsags ()
 (-let* (((m d y) (calendar-gregorian-from-absolute (+ 6 (org-today))))
           (target-date (format "%d-%02d-%02d" y m d))
        )
  (setq org-super-agenda-groups
         `(
           (:name "clocked"
            :log clock)
           (:name "next"
            :todo "Next")
           (:name "refile"
            :category "refile")
           (:name "blocked"
            :todo "Blocked")
           (:name "stuff"
            :and (:scheduled nil
                  :not (:log clock)))
           (:name "a while"
            :scheduled (after ,target-date))
           (:name ""
            :scheduled t
            :discard (:habit t))
           (:discard (:habit t)
            :name "errors")
          ))))

(after! org
  (use-package! org-random-todo
    :defer-incrementally t
    :commands (org-random-todo-mode
               org-random-todo
               org-random-todo-goto-current
               org-random-todo-goto-new)
    :config
    (setq org-random-todo-how-often 1000)
    (org-random-todo-mode 1))

  (after! alert
    (alert-add-rule :mode 'org-mode
                    :category "random-todo"
                    :style 'osx-notifier
                    :continue t)))

(defun org-agenda-habit-mode (&optional junk)
  "Toggle showing all habits."
  (interactive "P")
  (setq org-habit-show-all-today (not org-habit-show-all-today))
  (org-agenda-redo)
  (message "All habits are %s" (if org-habit-show-all-today "on" "off")))

(after! org-agenda
  (map! :map org-agenda-mode-map
        :localleader
        (:nvm "l" #'org-agenda-log-mode
         :nvm "h" #'org-agenda-habit-mode)))

(use-package! org-super-agenda
  :config
   (make-qsags)
   (org-super-agenda-mode 1)
   (setq org-agenda-custom-commands
         '(("z" "custom agenda"
            ((agenda "" ((org-agenda-span 'week)
                         (org-super-agenda-groups nil)
                         (org-agenda-overriding-header "")))
             (alltodo "" ((org-agenda-overriding-header "")
                          )))))))

(use-package! origami)

(use-package! org-cliplink)

(use-package! org-super-links
  :config
  (map! :map org-mode-map
        :localleader
        (:prefix ("m" . "backlinks")
         :nvm "l" #'org-super-links-link
         :nvm "s" #'org-super-links-store-link
         :nvm "i" #'org-super-links-insert-link
         :nvm "d" #'org-super-links-delete-link
         :nvm "c" #'org-super-links-convert-link-to-super)))

;; https://emacs.stackexchange.com/questions/44664/apply-ansi-color-escape-sequences-for-org-babel-results
(defun ek/babel-ansi ()
  (when-let ((beg (org-babel-where-is-src-block-result nil nil)))
    (save-excursion
      (goto-char beg)
      (when (looking-at org-babel-result-regexp)
        (let ((end (org-babel-result-end))
              (ansi-color-context-region nil))
          (ansi-color-apply-on-region beg end))))))

(defun display-ansi-colors ()
    (interactive)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max))))

(defun org-yank-into-new-elisp-block ()
    (interactive)
    (let ((begin (point))
          done)
      (unwind-protect
          (progn
            (end-of-line)
            (yank)
            (push-mark begin)
            (setq mark-active t)
            (org-insert-structure-template "src elisp")
            (setq done t)
            (deactivate-mark)
            (let ((case-fold-search t))
              (re-search-forward (rx bol "#+END_")))
            (forward-line 1))
        (unless done
          (deactivate-mark)
          (delete-region begin (point))))))

(defun org-yank-into-new-block ()
    (interactive)
    (let ((begin (point))
          done)
      (unwind-protect
          (progn
            (end-of-line)
            (yank)
            (push-mark begin)
            (setq mark-active t)
            (call-interactively #'org-insert-structure-template)
            (setq done t)
            (deactivate-mark)
            (let ((case-fold-search t))
              (re-search-forward (rx bol "#+END_")))
            (forward-line 1))
        (unless done
          (deactivate-mark)
          (delete-region begin (point))))))

(after! org
  (map! :map org-mode-map
        "C-c C-'" #'org-yank-into-new-block
        "C-c C-." #'org-yank-into-new-elisp-block))

;; style tweaks
;;
(defun style/left-frame ()
  (interactive)
  (cond
   ((string-equal system-type "windows-nt") ; Microsoft Windows
    (progn
      (set-frame-parameter (selected-frame) 'fullscreen nil)
      (set-frame-parameter (selected-frame) 'vertical-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'horizontal-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'top 10)
      (set-frame-parameter (selected-frame) 'left 6)
      (set-frame-parameter (selected-frame) 'height 40)
      (set-frame-parameter (selected-frame) 'width 120)))
   ((string-equal system-type "darwin") ; Mac OS X
    (progn
      (set-frame-parameter (selected-frame) 'fullscreen nil)
      (set-frame-parameter (selected-frame) 'vertical-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'horizontal-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'top 23)
      (set-frame-parameter (selected-frame) 'left 0)
      (set-frame-parameter (selected-frame) 'height 44)
      (set-frame-parameter (selected-frame) 'width 100)
      (message "default-frame set")))
   ((string-equal system-type "gnu/linux") ; linux
    (progn
      (message "Linux")))))

(defun style/right-frame ()
  (interactive)
  (cond
   ((string-equal system-type "windows-nt") ; Microsoft Windows
    (progn
      (set-frame-parameter (selected-frame) 'fullscreen nil)
      (set-frame-parameter (selected-frame) 'vertical-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'horizontal-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'top 10)
      (set-frame-parameter (selected-frame) 'left 2000)
      (set-frame-parameter (selected-frame) 'height 60)
      (set-frame-parameter (selected-frame) 'width 120)))
   ((string-equal system-type "darwin") ; Mac OS X
    (progn
      (set-frame-parameter (selected-frame) 'fullscreen nil)
      (set-frame-parameter (selected-frame) 'vertical-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'horizontal-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'top 0)
      (set-frame-parameter (selected-frame) 'left 707)
      (set-frame-parameter (selected-frame) 'height 44)
      (set-frame-parameter (selected-frame) 'width 100)))
   ((string-equal system-type "gnu/linux") ; linux
    (progn
      (message "Linux")))))

(add-to-list 'initial-frame-alist '(top . 23))
(add-to-list 'initial-frame-alist '(left . 0))
(add-to-list 'initial-frame-alist '(height . 44))
(add-to-list 'initial-frame-alist '(width . 100))

(defun style/max-frame ()
  (interactive)
  (if t
      (progn
        (set-frame-parameter (selected-frame) 'fullscreen 'fullboth)
        (set-frame-parameter (selected-frame) 'vertical-scroll-bars nil)
        (set-frame-parameter (selected-frame) 'horizontal-scroll-bars nil))
    (set-frame-parameter (selected-frame) 'top 26)
    (set-frame-parameter (selected-frame) 'left 2)
    (set-frame-parameter (selected-frame) 'width
                         (floor (/ (float (x-display-pixel-width)) 9.15)))
    (if (= 1050 (x-display-pixel-height))
        (set-frame-parameter (selected-frame) 'height
                             (if (>= emacs-major-version 24)
                                 66
                               55))
      (set-frame-parameter (selected-frame) 'height
                           (if (>= emacs-major-version 24)
                               75
                             64)))))

(after! doom-dashboard
  (message "post doom-dashboard")
  (style/left-frame)  ;; Focus new window after splitting
)

;; haskell
;;
(after! haskell
  (setq
   haskell-font-lock-symbols t
   haskell-interactive-popup-errors nil
   lsp-enable-folding nil
   lsp-response-timeout 120
   company-idle-delay nil
   lsp-ui-sideline-enable nil           ; not anymore useful than flycheck
   lsp-ui-doc-enable nil                ; slow and redundant with K
   lsp-enable-symbol-highlighting nil
   ;; If an LSP server isn't present when I start a prog-mode buffer, you
   ;; don't need to tell me. I know. On some systems I don't care to have a
   ;; whole development environment for some ecosystems.
   +lsp-prompt-to-install-server 'quiet
   )
 )


;; browse-kill-ring
(use-package! browse-kill-ring
  :config
  (map! :leader :n "y" #'browse-kill-ring))



(use-package! eshell-info-banner
:ensure t
  :defer t
  :hook (eshell-banner-load . eshell-info-banner-update-banner))

(use-package! wordnut
  :bind (:map doom-leader-map
         ("lW" . wordnut-search))
  :init
  (after! which-key
    (add-to-list 'which-key-replacement-alist
                 '((nil . "wordnut-search") . (nil . "Wordnut search"))))
  :config
  (map! :map wordnut-mode-map
        :nmv "q" #'quit-window))

;;(use-package! org-ql)
