export MMORPG_PG_PASSWORD:=d6c1d582-8af1-4154-88bb-91807eb209a9

.PHONY: all
all : sass
		python3.6 main.py

.PHONY: i
i : sass
		python3.6 -i main.py

.PHONY: sass
sass : static/css/style.css

%.css : %.scss
		sass $< $@
