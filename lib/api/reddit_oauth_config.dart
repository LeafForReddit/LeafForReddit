class RedditOAuthConfig {
  final String authorizationUrl = "https://www.reddit.com/api/v1/authorize";
  final String tokenUrl = "https://www.reddit.com/api/v1/access_token";
  final String clientId = "5_xIeZY2TqCK-w";
  final String redirectUri = "http://localhost:8080";
  final String duration = "permanent";
  final List<String> scope = [
    "identity",
    "edit",
    "flair",
    "history",
    "modconfig",
    "modflair",
    "modlog",
    "modposts",
    "modwiki",
    "mysubreddits",
    "privatemessages",
    "read",
    "report",
    "save",
    "submit",
    "subscribe",
    "vote",
    "wikiedit",
    "wikiread"
  ];
  final String responseType = "code";
}
