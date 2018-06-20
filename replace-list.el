;; remove ## lists

## here

    (setq getStart ":\n\n##") ;; ## after :
    (setq getStop "\n\n[^##]") ;; ## not followed by ##

(defun replace-in-region (beg end)
    ;; replace ## in region
    (interactive "r")       
    ;; (set-mark (point-min))
    (goto-char (re-search-forward getStart))
    (goto-char (re-search-backward "[a-z]:"))
    (push-mark)
    ;; (set-mark (re-search-forward getStart))
    ;;(set-mark (re-search-backward ":"))
    (goto-char (re-search-forward getStop))
    ;;(goto-char (point-max))
    (activate-mark)
  (save-restriction
    (narrow-to-region beg end)
    (goto-char (point-max))
    (while (re-search-backward "##" nil t)
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

(defun eriks-search-for-st ()
    (interactive)
    (goto-char (re-search-forward getStop))
)
