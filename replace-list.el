;; remove ## lists


;; SE: https://emacs.stackexchange.com/questions/32530/incorrect-value-of-region-end-in-function-that-calls-replace-string


;; ## here

    (setq getStart ":\n\n##") ;; ## after :
    (setq getStop "\n\n[^##]") ;; ## not followed by ##

(defun replace-in-region ()
  ;;beg end
    ;; replace ## in region
    (interactive)       ;; "r"
    ;; (set-mark (point-min))
    (goto-char (re-search-forward getStart))
    (set-mark (goto-char (re-search-backward "[a-z]:")))
    ;; (push-mark)
    ;; (set-mark (re-search-forward getStart))
    ;;(set-mark (re-search-backward ":"))
    (goto-char (re-search-forward getStop))
    ;;(goto-char (point-max))
    ;;(setq mark-active t)
   ;; (activate-mark)
 (save-restriction
    (narrow-to-region (region-beginning) (region-end))
    ;;(replace-string "##" "hello")
    ;;)
    (goto-char (point-min))
    (while (re-search-forward "##" nil t)
       (replace-match (if (eq (char-after (1- (point))) ?\ ) " " ""))
    ) ;; While
  )
)

## here

(defun eriks-back-to-colon ()
    (interactive
    (goto-char (re-search-backward ":"))))

(defun eriks-search-for-start ()
    (interactive)
    (goto-char (re-search-forward getStart))
)

(defun eriks-search-for-stop ()
    (interactive)
    (goto-char (re-search-forward getStop))
)



;; #####

;; text <- "mark:\n\n## Headera\n\n## Headerb\n\nNote"

;; (while (re-search-forward "hello" nil t)
;;     (replace-match "world"))

;; (defun my-select-current-line ()
;;   (interactive)
;;   (move-beginning-of-line nil)
;;   (set-mark-command nil)
;;   (move-end-of-line nil)
;;     (setq deactivate-mark nil))

;; goto-char position

;; ;; return the beginning position of buffer
;; (point-min)

;; ;; returns the position for the end of buffer, respect narrow-to-region
;; (point-max)

;; http://ergoemacs.org/emacs/elisp_cursor_position.html

;; ## re-search-forward → move cursor forward by searching for regex pattern. Cursor stops at end of matched pattern.

;; ;; move cursor to the location matched by regex
;; ;; returns the new position

;; (setq getStart ":\n\n##")
;; (setq getStop "\n\n[^##]")
;; (re-search-forward getStart)
;; (push-mark)
;; (re-search-forward getStop)
;; (push mark)
;; (re-search-backward myRegex)
;; ;;    (replace-regexp "##" "hello" (region-beginning) (region-end))

;; ##
;; (defun collapse-list ()
;;     (interactive)
;;     ;; Remove ## from lists preceded by :
;;     (point-min) ;; go to start of buffer
;;     (setq getStart ":\n\n##") ;; ## after :
;;     (setq getStop "\n\n[^##]") ;; ## not followed by ##
;;    ;; (re-search-forward getStart)
;;     (set-mark (re-search-forward getStart))
;;     (goto-char (re-search-forward getStop))
    
;; ;;    (push-mark)
;; ;;    (activate-mark)
;;     (setq mark-active t)
;;     ;;  (set-mark (re-search-forward getStart))
;; ;;    (set-mark (re-search-forward getStop))
;; ;;    (push-mark)
;; ;;    (re-search-forward getStop)

;;     ;;   (push-mark)
;; ;;    (setq startPos (make-marker))
;; ;;    (setq stopPos (make-marker))
;; ;;    (setq startPos (14548))
;; ;;    (setq stopPos (14628))
;;  ;;       (replace-string "##" "hello")
;;     ;; (replace-regexp "##" "hello" "14548" "14628")
;;    ;;(replace-regexp "##" "hello") ;; whole buffer

;;     (let(
;;     (startPos (region-beginning))
;;     (stopPos (region-end))    
;;     )
;;         (replace-regexp "##" "hello" startPos stopPos)
;;     )

;;     ;;     
;;     ;;(print stopPos)
;; )

;; (defun replace-in-region (beg end)
;;     ;; replace ## in region
;;   (interactive "r")
;;   (save-restriction
;;     (narrow-to-region beg end)
;;     (goto-char (point-min))
;;     (while (re-search-forward "##" nil t)
;;       (replace-match (if (eq (char-after (1- (point))) ?\ ) " " "")))))




;; (defun collapse-list ()
;;     (interactive)
;;     ;; Remove ## from lists preceded by :
;;     (progn
;;     (point-min) ;; go to start of buffer
;;     (setq getStart ":\n\n##") ;; ## after :
;;     (setq getStop "\n\n[^##]") ;; ## not followed by ##
;;     (re-search-forward getStart)
;;     (push-mark)
;;     ;;(set-mark (re-search-forward getStart))
;;         (goto-char (re-search-forward getStop))
;;         (setq mark-active t)
;;     (replace-in-region (beg end))

;;     ))


;; (defun collapse-list ()
;;     (interactive)
;; (set-mark (point-min))
;;     (goto-char (point-max))
;;     (activate-mark)
;; )


;; (defun replace-in-region (beg end)
;;     ;; replace ## in region
;;     (interactive "r")       
;; (set-mark (point-min))
;;     (goto-char (point-max))
;;     (activate-mark)
;;   (save-restriction
;;     (narrow-to-region beg end)
;;     (goto-char (point-min))
;;     (while (re-search-forward "##" nil t)
;;       (replace-match (if (eq (char-after (1- (point))) ?\ ) " " "")))))



;; (goto-char (re-search-forward getStart))
;; (set-mark (re-search-forward getStart))
;; (goto-char (re-search-forward getStop))

;; (Replace-regexp "##" "hello" 14548 14628)

;; Coding note: Specify all academic domains and subskills that are impaired. When more than one domain is impaired, each one should be coded individually according to the following specifiers.

;; ## Header here

;; _Specify_ if:

;; 315.00 (F81.0) With impairment in reading:

;; ## Word reading accuracy 

;; ## Reading rate or fluency 

;; ## Reading comprehension

;;     Note: Dyslexia is an alternative term used to refer to a pattern of learning difficulties characterized by problems with accurate or fluent word recognition, poor decoding, and poor spelling abilities. If dyslexia is used to specify this particular pattern of difficulties, it is important also to specify any additional
