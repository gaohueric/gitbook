<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.css">
<script src="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.min.js"></script>
<div id="gitalk-container"></div>
var gitalk = new Gitalk({
  "clientID": "651adc5a61d0b6f57056",
  "clientSecret": "651adc5a61d0b6f57056",
  "repo": "gitbook",
  "owner": "gaohueric",
  "admin": ["gaohueric"],
  "id": location.pathname,
  "distractionFreeMode": false
});
gitalk.render("gitalk-container");
