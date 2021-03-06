% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/github.R
\name{browse_github_token}
\alias{browse_github_token}
\alias{browse_github_pat}
\alias{github_token}
\title{Create and retrieve a GitHub personal access token}
\usage{
browse_github_token(
  scopes = c("repo", "gist", "user:email"),
  description = "R:GITHUB_PAT",
  host = "https://github.com"
)

browse_github_pat(
  scopes = c("repo", "gist", "user:email"),
  description = "R:GITHUB_PAT",
  host = "https://github.com"
)

github_token()
}
\arguments{
\item{scopes}{Character vector of token scopes, pre-selected in the web
form. Final choices are made in the GitHub form. Read more about GitHub
API scopes at
\url{https://developer.github.com/apps/building-oauth-apps/scopes-for-oauth-apps/}.}

\item{description}{Short description or nickname for the token. It helps you
distinguish various tokens on GitHub.}

\item{host}{GitHub API host to use. Override with the endpoint-root for your
GitHub enterprise instance, for example,
"https://github.hostname.com/api/v3".}
}
\value{
\code{github_token()} returns a string, a GitHub PAT or \code{""}.
}
\description{
A \href{https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line}{personal access token}
(PAT) is needed for git operations via the GitHub API. Two helper functions
are provided:
\itemize{
\item \code{browse_github_token()} is synonymous with \code{browse_github_pat()}: Both
open a browser window to the GitHub form to generate a PAT. See below for
advice on how to store this.
\item \code{github_token()} retrieves a stored PAT by consulting, in this order:
\itemize{
\item \code{GITHUB_PAT} environment variable
\item \code{GITHUB_TOKEN} environment variable
\item the empty string \code{""}
}
}
}
\section{}{
 Get and store a PAT:
Sign up for a free \href{https://github.com/}{GitHub.com} account and sign in.
Call \code{browse_github_token()}. Verify the scopes and click "Generate token".
Copy the token right away! A common approach is to store in \code{.Renviron} as
the \code{GITHUB_PAT} environment variable. \code{\link[=edit_r_environ]{edit_r_environ()}} opens this file for
editing.
}

\examples{
\dontrun{
browse_github_token()
## COPY THE PAT!!!
## almost certainly to be followed by ...
edit_r_environ()
## which helps you store the PAT as an env var
}
# for safety's sake, just reveal first 4 characters
substr(github_token(), 1, 4)
}
\seealso{
\code{\link[gh:gh_whoami]{gh::gh_whoami()}} for information on an existing token.
}
