# 简介
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.css">
<script src="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.min.js"></script>
<div id="gitalk-container"></div>
var gitalk = new Gitalk({
  "clientID": "066777d9c6fd8f5647c4",
  "clientSecret": "6d7254cd0a0fb51691e9a4a05bfe8665a5238493",
  "repo": "gitbook",
  "owner": "gaohueric",
  "admin": ["gaohueric"],
  "id": location.pathname,
  "distractionFreeMode": false
});
gitalk.render("gitalk-container");
