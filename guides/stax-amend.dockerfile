FROM taras0mazepa/stax-guide-base:0.10.2

RUN echo "# Demo Repository" > README.md && \
    git add README.md && \
    git commit -m "Initial commit" && \
    git branch -M main && \
    git push -u origin main

RUN git checkout -b feature-navigation && \
    mkdir -p src/components && \
    echo "function NavBar() { /* initial implementation */ }" > src/components/NavBar.js && \
    git add src/components/NavBar.js && \
    git commit -m "Add navigation bar component" && \
    git push origin feature-navigation

RUN echo "function NavItem() { /* implementation */ }" >> src/components/NavBar.js && \
    echo ".navbar { display: flex; }" > src/components/NavBar.css
