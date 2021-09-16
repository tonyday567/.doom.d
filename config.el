;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; other configuration examples
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
;; (setq doom-theme 'doom-oceanic-next)
(setq doom-theme 'doom-Iosvkem)
;; (doom-themes-org-config)

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

(setq evil-split-window-below t
      evil-vsplit-window-right t
      confirm-kill-emacs nil
      shift-select-mode t
      window-combination-resize t
      delete-selection-mode t
      case-fold-search t
      auto-save-default t)

;; setq-default sets variables that are usually local to buffers
(setq-default truncate-lines nil
              indent-tabs-mode nil)

(setq vertico-sort-function #'vertico-sort-history-alpha)

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

(use-package! browse-kill-ring
  :config
  (map! :leader :n "y" #'browse-kill-ring))

(use-package! discover-my-major)

(use-package! keyfreq
  :after-call post-command-hook
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

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
%a")))))

(after! org
  :config
  (setq
   org-superstar-headline-bullets-list '("⁖")
   org-startup-folded 'overview
   org-support-shift-select t
   org-startup-folded t
   org-insert-heading-respect-content nil)
   org-ellipsis " [...] "
  ;; flyspell off for org mode
  (remove-hook 'org-mode-hook 'flyspell-mode))

(map! (:after evil-org
       :map evil-org-mode-map
       :n "gk" (cmd! (if (org-on-heading-p)
                         (org-backward-element)
                       (evil-previous-visual-line)))
       :n "gj" (cmd! (if (org-on-heading-p)
                         (org-forward-element)
                       (evil-next-visual-line)))))

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
    (map! :leader "oz" #'agenda-z)
 )

(defun agenda-z ()
  (interactive)
  (org-agenda nil "z"))

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

(after! org
  :config
  (defun display-ansi-colors ()
    (interactive)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max))))
   (add-hook 'org-babel-after-execute-hook #'display-ansi-colors)

   (map! :map org-mode-map
        "C-c C-'" #'org-yank-into-new-block
        "C-c C-." #'org-yank-into-new-elisp-block)
)

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

;; FIXME: not turning on
(use-package! org-wild-notifier
  :defer t
  :config
  (add-hook! 'after-init-hook 'org-wild-notifier-mode)
  (setq ;;org-wild-notifier-alert-time 15
        alert-default-style (if IS-MAC 'osx-notifier 'libnotify)))

(after! org
  (use-package! org-random-todo
    :defer-incrementally t
    :commands (org-random-todo-mode
               org-random-todo
               org-random-todo-goto-current
               org-random-todo-goto-new)
    :config
    (setq org-random-todo-how-often 6000)
    (org-random-todo-mode 1))

  (after! alert
    (alert-add-rule :mode 'org-mode
                    :category "random-todo"
                    :style 'osx-notifier
                    :continue t)))

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

;; haskell
;;
(after! haskell
  (setq
   haskell-font-lock-symbols t
   company-idle-delay nil
   haskell-interactive-popup-errors nil
   lsp-enable-folding nil
   lsp-response-timeout 120
   lsp-ui-sideline-enable nil
   lsp-ui-doc-enable nil
   lsp-enable-symbol-highlighting nil
   +lsp-prompt-to-install-server 'quiet
   lsp-modeline-diagnostics-scope :project
   lsp-modeline-code-actions-segments '(count icon))
  (global-so-long-mode -1))

(use-package! tidal
    :init
    (progn
      ;; (setq tidal-interpreter "ghci")
      ;; (setq tidal-interpreter-arguments (list "ghci" "-XOverloadedStrings" "-package" "tidal"))
      ;; (setq tidal-boot-script-path "~/.emacs.doom/.local/straight/repos/Tidal/BootTidal.hs")
      ))

(use-package! corfu
  :bind (:map corfu-map
         ("C-j" . corfu-next)
         ("C-k" . corfu-previous)
         ("C-f" . corfu-insert))
  :custom
  (corfu-cycle t)
  :config
  (corfu-global-mode))

(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package popup-kill-ring
  :bind ("M-y" . popup-kill-ring))
