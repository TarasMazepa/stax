FROM taras0mazepa/stax-guide-base:0.10.2

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

RUN mkdir -p /usr/local/bin
RUN echo '#!/bin/bash' > /usr/local/bin/open
RUN echo 'echo "===== BROWSER SIMULATION ====="' >> /usr/local/bin/open
RUN echo 'echo "Opening URL: $1"' >> /usr/local/bin/open
RUN echo 'echo "This would open a browser to create a pull request in a real environment."' >> /usr/local/bin/open
RUN echo 'echo "============================"' >> /usr/local/bin/open
RUN chmod +x /usr/local/bin/open

RUN echo 'echo -e "\n===== stax commit demo =====\n"' > /home/stax/.bashrc
RUN echo 'echo "This demo shows how to use stax commit command:"' >> /home/stax/.bashrc
RUN echo 'echo -e "\n * stax commit \"message\" - creates a branch, commits, and pushes changes"' >> /home/stax/.bashrc
RUN echo 'echo " * stax commit -a \"message\" - adds all files before committing"' >> /home/stax/.bashrc
RUN echo 'echo " * stax commit -u \"message\" - adds only tracked files"' >> /home/stax/.bashrc
RUN echo 'echo " * stax commit -p \"message\" - creates PR after pushing"' >> /home/stax/.bashrc
RUN echo 'echo " * stax commit -b \"message\" - accepts branch name from commit message"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nTry out different combinations of flags!\n"' >> /home/stax/.bashrc
RUN echo 'cd /home/stax/repo' >> /home/stax/.bashrc

ENV ENV=/home/stax/.bashrc