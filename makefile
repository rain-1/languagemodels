all: lint test

.PHONY: test lint format spellcheck upload clean

test:
	python3 -m doctest -o ELLIPSIS -o NORMALIZE_WHITESPACE languagemodels/*.py
	env LANGUAGEMODELS_SIZE=large python3 -m doctest -o ELLIPSIS -o NORMALIZE_WHITESPACE languagemodels/*.py
	env LANGUAGEMODELS_SIZE=xl python3 -m doctest -o ELLIPSIS -o NORMALIZE_WHITESPACE languagemodels/*.py

lint:
	flake8 --max-line-length 88 --extend-ignore E203,F401 languagemodels/__init__.py
	flake8 --max-line-length 88 --extend-ignore E203 languagemodels/models.py languagemodels/inference.py languagemodels/embeddings.py examples/*.py

format:
	black languagemodels/*.py examples/*.py

doc:
	mkdir -p doc
	python3 -m pdoc -o doc languagemodels

paper.pdf: paper.md paper.bib
	pandoc $< --citeproc -o $@

spellcheck:
	aspell -c --dont-backup readme.md
	aspell -c --dont-backup paper.md

upload:
	python3 setup.py sdist bdist_wheel
	python3 -m twine upload dist/*

clean:
	rm -rf tmp
	rm -rf languagemodels.egg-info
	rm -rf languagemodels/__pycache__
	rm -rf dist
	rm -rf build
	rm -rf doc
	rm -rf .ipynb_checkpoints
	rm -rf examples/.ipynb_checkpoints
