(use-package docker
  :ensure t
  :defer t)

(use-package dockerfile-mode
  :ensure t
  :defer t
  :hook
  (dockerfile-mode . (lambda ()
                       (eldoc-mode t)
                       (eglot-ensure))))

(provide 'infra-docker)
