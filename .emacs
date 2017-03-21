;; ************************************************************************** ;;
;;           .      .@@                                                       ;;
;;          $@#.@#$..@$@`     $                                               ;;
;;        `##@$@@@$$$#@$##@@@#                                                ;;
;;     $@@##@$$###$##@@@@@@#$$@@#                                             ;;
;;    `#$$$##################@`                                               ;;
;;    #$##^$################$#$       .emacs                                  ;;
;;   #$#<--->@#######$##########.                                             ;;
;;   ####$v####.        `####$ #.     By: cdivry@student.42.fr                ;;
;;   ####$####$`        .###  .                                               ;;
;;    .########################                                               ;;
;;     .$#$###################.                                               ;;
;;       `#################$.                                                 ;;
;;         `$$############$.`     Created: 2013/11/28 07:04:35 by cdivry      ;;
;;           `#$##########.       Updated: 2017/03/21 07:04:35 by cdivry      ;;
;;              `$#$$$$#$                                                     ;;
;;                  ##$.                                                      ;;
;; ************************************************************************** ;;

;; chargement complet de la config lisp
(setq config_files "/usr/share/emacs/site-lisp/")
(setq load-path (append (list nil config_files) load-path))
(set-language-environment "UTF-8")


;; Un code en C est automatiquement indenté avec des tabulations
(defun set-newline-and-indent ()
  (local-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'lisp-mode-hook 'set-newline-and-indent)

;; Une paire (parenthèse ou accolade) est automatique fermée
;; lorsque vous saisissez l’élément ouvrant
(electric-pair-mode 1)
(setq electric-pair-pairs '(
							(?\" . ?\")
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\{ . ?\})
                           ))

;; La colonne de position du curseur est affichée
(column-number-mode t)

;; Deux espaces côte-à-côte sont highlightés
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "  " t)
			))

;; Un whitespace avant un retour à la ligne est highlighté
(setq show-trailing-whitespace t)
(setq-default show-trailing-whitespace t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Auto save              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Les fichiers de sauvegarde (se terminant par ~) sont archivés
;; dans un dossier spécifique à l’intérieur du dossier ~/.emacs.d
(defvar my-auto-save-folder "~/.emacs.d/auto-save")
(setq auto-save-list-file-prefix "~/.emacs.d/auto-save/saved-")
(setq auto-save-file-name-transforms `((".*" ,my-auto-save-folder t)))
(setq tramp-auto-save-directory my-auto-save-folder);

;; desactive auto-save (#...#) et auto-backup (...~)
(setq auto-save-default nil)
(setq make-backup-files nil)

;;          CF normalize_emacs          ;;

;(if (file-exists-p "~/.emacs.d/normalize_emacs")
;	(load-file "~/.emacs.d/normalize_emacs")
;)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;              Header custom             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun custom-header-filename() (concat (format "%-38s" (current-buffer))))
(defun custom-header-mail() (concat (format "%-34s" (concat (getenv "USER") " <" (getenv "MAIL") ">"))))
(defun custom-header-created-time() (concat (format "%-29s" (concat (format-time-string "%Y/%m/%d %T") " by " (getenv "USER")))))
(defun custom-header-updated-time() (concat (format "%-29s" (concat (format-time-string "%Y/%m/%d %T") " by " (getenv "USER")))))


(defun make-custom-header()
  (concat
   "/*" " ************************************************************************** */" "\n"
   "/*" "           .      .@@                                                       */" "\n"
   "/*" "          $@#.@#$..@$@`     $                                               */" "\n"
   "/*" "        `##@$@@@$$$#@$##@@@#                                                */" "\n"
   "/*" "     $@@##@$$###$##@@@@@@#$$@@#                                             */" "\n"
   "/*" "    `#$$$##################@`                                               */" "\n"
   "/*" "    #$##^$################$#$       " (custom-header-filename)               "  */" "\n"
   "/*" "   #$#<--->@#######$##########.                                             */" "\n"
   "/*" "   ####$v####.        `####$ #.     By: " (custom-header-mail)               "  */" "\n"
   "/*" "   ####$####$`        .###  .                                               */" "\n"
   "/*" "    .########################                                               */" "\n"
   "/*" "     .$#$###################.                                               */" "\n"
   "/*" "       `#################$.                                                 */" "\n"
   "/*" "         `$$############$.`     Created: " (custom-header-created-time)  "      */" "\n"
   "/*" "           `#$##########.       Updated: " (custom-header-updated-time)  "      */" "\n"
   "/*" "              `$#$$$$#$                                                     */" "\n"
   "/*" "                  ##$.                                                      */" "\n"
   "/*" " ************************************************************************** */" "\n"
   )
)
(defun remake-custom-header()
  (message "Updating Header...")
  (concat "/*" "           `#$##########.       Updated: " (custom-header-updated-time)  "      */")
)

(defun check-if-custom-header-exists()
  (if(> (buffer-size) 501)
	  (string-equal (buffer-substring-no-properties 1 501)
					(substring (make-custom-header) 0 500)
	  )
	nil
  )
)
(check-if-custom-header-exists)

(defun check-if-buffer-updated ()

  (if(> (buffer-size) 801)
	  (string-equal ((buffer-substring-no-properties 721 801))
					(substring (make-custom-header) 720 800)
	  )
    nil
	)
)
(check-if-buffer-updated)

(defun update-custom-header()
  (interactive)
  (if (and (check-if-custom-header-exists) (buffer-modified-p))
	  (save-excursion
		(progn
		  (goto-char 0)
		  (if (search-forward "Updated: " nil t)
			  (progn
				(delete-region
				 (progn (beginning-of-line) (point))
				 (progn (end-of-line) (point)))
				(insert (remake-custom-header))
				)
			)
		  )
		)
	)
  )

(defun custom-header()
  (interactive)
  (if (not(check-if-custom-header-exists))
	  (
	    save-excursion
		(goto-char 0)
		(insert (make-custom-header))
	  )
  )
)
(add-hook 'before-save-hook 'update-custom-header)

(defun custom-apply-norm()
  (interactive)
)

(provide 'custom-header)

(global-set-key (kbd "C-c h") 'custom-header)

;; Activer la coloration syntaxique
(global-font-lock-mode t)

;; tabulations de 4 chars
;; correction des tabulations
(setq-default tab-width 4)
(setq-default indent-tabs-mode t)
(setq-default c-basic-offset 4)

;; n'indente pas les acollades
(setq-default c-default-style "linux")

;; La ligne de position du curseur est affichée
(line-number-mode t)

;; affiche la limite des 80 caracterexs
;; a la fin de chaque ligne
;; en highlightant ce qui depasse
(require 'whitespace)
(setq whitespace-line-column 80)
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode)

;; les commentaires C++ sont highlightes
(add-hook 'c-mode-common-hook (lambda() (highlight-regexp "//" t)))

;; highlight sur la ligne actuelle
(global-hl-line-mode 1)
;;(set-face-background 'hl-line "#111111")

;; Load user configuration
(if (file-exists-p "~/.myemacs") (load-file "~/.myemacs"))

;; highlight de la parenthese correspondante
(show-paren-mode 1)

;; highlight if mal formate
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "if(" t)
			))

;; highlight while mal formate
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "while(" t)
			))

;; highlight break mal formate
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "break;" t)
			))

;; highlight parentheses mal formatees
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "( " t)
			))
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp " )" t)
			))

;; highlight crochets mal formates
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "[ " t)
			))
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp " ]" t)
			))

;; highlight fonctions interdites 
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "for (" t)
			))
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "for(" t)
			))
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "foreach" t)
			))

;; highlight declaration de variable mal formatee
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "int " t)
			))
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "int*" t)
			))
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "char " t)
			))
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "char*" t)
			))
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "float " t)
			))
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "float*" t)
			)
		  )
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "double " t)
			))
(add-hook 'c-mode-common-hook
		  (lambda() (highlight-regexp "double*" t)
			))


;;(setq-default font-lock-global-modes nil)
;;(setq-default line-number-mode nil)
;;(global-set-key (kbd "DEL") 'backward-delete-char)
;;(setq-default c-backspace-function 'backward-delete-char)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(gud-gdb-command-name "gdb --annotate=1")
 '(inhibit-startup-screen t)
 '(large-file-warning-threshold nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; affiche le numero de ligne dans la marge de gauche
(add-hook 'prog-mode-hook 'linum-mode)
(setq linum-format "%4d \u2502 ")

;; raccourci CTRL-C L pour desactiver/activer linum
(global-set-key (kbd "C-c l") 'linum-mode)
