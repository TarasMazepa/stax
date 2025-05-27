FROM taras0mazepa/stax-guide-base:0.10.5

RUN touch auth.md
RUN stax c -ab "feature auth"

RUN touch auth.js
RUN stax c -ab "feature password reset"

RUN git checkout main
RUN touch ui.md
RUN stax c -ab "feature ui"

RUN touch styles.css
RUN stax c -ab "feature dark theme"

RUN git checkout feature-ui
RUN touch styles.css
RUN stax c -ab "feature responsive"

RUN git checkout main
RUN touch LICENSE.md
RUN git add LICENSE.md
RUN git commit -m "Adds LICENSE.md"
RUN git push

ENV ENV=/home/stax/.bashrc
