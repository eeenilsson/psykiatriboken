;; Function to remove ## in lists in DSM5 import

(defun replace-bounded-hash ()
  ;; replace '##' with '-' in region bounded by getStart and getStop strings.
  ;; getStart and getStop are defined inside function lisp.
  ;; ends with "search failed" when no more matches are found.
  (interactive)
  (let (
	(getStart ":\n\n##") ;; ## after :
	(getStop "\n\n[^##]") ;; ## not followed by ##
	)
    ;; let body start
    (while (< (point) (point-max))
      (goto-char (re-search-forward getStart))
      (set-mark (goto-char (re-search-backward "[a-z]:")))
      (goto-char (re-search-forward getStop))
      (save-restriction
	(narrow-to-region (region-beginning) (region-end))
	(goto-char (point-min))
	(while (re-search-forward "##" nil t) ;; 
	  (replace-match (if (eq (char-after (1- (point))) ?\ ) " " "-"))))
      (deactivate-mark))))


;; http://ergoemacs.org/emacs/elisp_cursor_position.html
;; https://emacs.stackexchange.com/questions/32530/incorrect-value-of-region-end-in-function-that-calls-replace-string

;; test on text below
;; Coding note: Specify all academic domains and subskills that are impaired. When more than one domain is impaired, each one should be coded individually according to the following specifiers.

;; ## Header here

;; _Specify_ if:

;; 315.00 (F81.0) With impairment in reading:

;; ## Word reading accuracy 

;; ## Reading rate or fluency 

;; ## Reading comprehension

;;     Note: Dyslexia is an alternative term used to refer to a pattern of learning difficulties characterized by problems with accurate or fluent word recognition, poor decoding, and poor spelling abilities. If dyslexia is used to specify this particular pattern of difficulties, it is important also to specify any additional
