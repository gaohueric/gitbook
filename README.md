<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.css">
<script src="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.min.js"></script>
<div id="gitalk-container"></div>
var gitalk = new Gitalk({
  "clientID": "clientId",
  "clientSecret": "clientSecret",
  "repo": "GitHub repo",
  "owner": "GitHub repo owner",
  "admin": ["GitHub repo admin"],
  "id": location.pathname,
  "distractionFreeMode": false
});
gitalk.render("gitalk-container");
