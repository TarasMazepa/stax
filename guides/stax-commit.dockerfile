FROM taras0mazepa/stax-guide-base:0.10.2

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
RUN echo 'echo -e "\nUsage: stax commit \"commit message\" [branch name]"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nThe commit message is required and should be in quotes, like: \"Fix button styling\""' >> /home/stax/.bashrc
RUN echo 'echo "The branch name is optional - if not provided, it will be generated from the commit message"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nFlags:"' >> /home/stax/.bashrc
RUN echo 'echo " * -A     - Add all tracked and untracked files in entire working tree"' >> /home/stax/.bashrc
RUN echo 'echo " * -a     - Add all tracked and untracked files in current folder and subfolders"' >> /home/stax/.bashrc
RUN echo 'echo " * -u     - Add only tracked files in entire working tree"' >> /home/stax/.bashrc
RUN echo 'echo " * -b     - Accept branch name generated from commit message"' >> /home/stax/.bashrc
RUN echo 'echo " * -i     - Skip check for staged changes (useful for renames)"' >> /home/stax/.bashrc
RUN echo 'echo " * -p     - Create and open PR after pushing (GitHub only)"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nExample: stax commit -a \"Fix button styling\" button-fix\n"' >> /home/stax/.bashrc
RUN echo 'cd /home/stax/repo' >> /home/stax/.bashrc

ENV ENV=/home/stax/.bashrc