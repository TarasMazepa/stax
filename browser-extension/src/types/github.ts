export interface GitHubUser {
  login: string;
  avatar_url: string;
  name: string;
}

export interface GitHubPR {
  number: number;
  title: string;
  html_url: string;
  user: {
    login: string;
    avatar_url: string;
  };
  base: {
    ref: string;
  };
  head: {
    ref: string;
  };
}

export interface AuthState {
  token: string | null;
  user: GitHubUser | null;
  customDomain: string;
}
