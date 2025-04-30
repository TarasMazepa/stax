FROM taras0mazepa/stax-guide-base:0.10.3

RUN touch README.md
RUN git add README.md
RUN git commit -m "Initial commit"
RUN git branch -M main
RUN git push

RUN git checkout main
RUN touch LICENSE.md
RUN git add LICENSE.md
RUN git commit -m "Adds LICENSE.md"
RUN git push

RUN touch fix-button.txt 
RUN stax commit -ab "fix button"

RUN mkdir -p /home/stax/second-repo
WORKDIR /home/stax/second-repo
RUN git clone /home/stax/origin .

RUN touch navigation.txt
RUN git add .
RUN git commit -m "Adds navigation.txt"
RUN git push

WORKDIR /home/stax/repo
RUN git checkout main && git pull && git checkout fix-button
