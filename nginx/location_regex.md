# Nginx location

__For nginx regex tests <https://nginx.viraptor.info/>__

## Search-Order

|Search-Order|Modifier|Description|Match-Type|Stops-search-on-match|
|--|--|--|--|--|
|1st    | =      |The URI must match the specified pattern exactly| String | Yes|
|2nd    | ^~     |The URI must begin with the specified pattern   | String | Yes|
|3rd    | (None) |The URI must begin with the specified pattern   | String | No |
|4th    | ~      |The URI must be a case-sensitive match to the specified Rx| Perl-Compatible-Rx| Yes (first match)|
|4th    | ~*     |The URI must be a case-insensitive match to the specified Rx| Perl-Compatible-Rx| Yes (first match)|
|N/A    | @      |Defines a named location block.| String| Yes|

## Capturing group

Capturing group, expression evaluation ```()``` are supported, this example ```location ~ ^/(?:index|update)$``` match url ending with ```example.com/index``` and ```example.com/update```

|Capture|Description|
|--|--|
|```()``` | Group/Capturing-group, capturing mean match and retain/output/use what matched the patern inside ```()```. The default bracket mode is "capturing group" while ```(?:)``` is a non capturing group.For example __(?:a&#124;b)__ match a or b in a non capturing mode. |
|```?:``` | Non capturing group|
|```?=``` | Positive look ahead|
|```?!``` | For negative look ahead (do not match the following...)|
|```?<=```| For positive look behind|
|```?<!```|   : is for negative look behind|

## The forward slash

Not to confuse with the regex slash ```\```, In nginx the forward slash ```/``` is used to match any sub location including none example ```location /```. In the context of regex support ```/``` doesn't actually do anything. In Javascript, Perl and some other languages, it is used as a delimiter character explicitly for regular expressions. Some languages like PHP use it as a delimiter inside a string, with additional options passed at the end, just like Javascript and Perl.

__Nginx does not use delimiter ```/```__. It can be escaped with ```\/``` for code portability purpose but this is not required for nginx. __```/``` are handled literally__ (don't have other meaning than ```/```)

## The slash

The first purpose of the regex special character ```\``` is meant to escape the next character; But note that in most case ```\``` followed by a character have a different meaning. A complete list is available in <https://www.regular-expressions.info/refquick.html>.

## Other regex chars

|Regex|Description|
|--|--|
|```~```| Enable regex mode for location (in regex ~ mean case-sensitive match)|
|```~*```| Case-insensitive match|
|__&#124;__| Or|
|```()```| Match group or evaluate the content of ()|
|```$```| the expression must be at the end of the evaluated text (no char/text after the match) __$__ is usually used at the end of a regex location expression.|
|```?```| Check for zero or one occurrence of the previous char ex jpe?g|
|```^~```| The match must be at the beginning of the text, note that nginx will not perform any further regular expression match even if an other match is available; __^__ indicate that the match must be at the start of the uri text, while __~__ indicates a regular expression match mode. Example ```location ^~ /realestate/.*``` |
|```=```| Exact match, no sub folders. Example ```location = /```|
|```^```| Match the beginning of the text (opposite of $). By itself, ^ is a shortcut for all paths.|
|```.*```| Match zero, one or more occurrence of any char|
|```\```| Escape the next char|
|```.```| Any char|
|```*```| Match zero, one or more occurrence of the previous char|
|```!```| Not |
|```{}```| Match a specific number of occurrence ex. [0-9]{3} match 342 but not 32; {2,4} match length of 2, 3 and 4|
|```+```| Match one or more occurrence of the previous char|
|```[]```| Match any char inside|

## Examples

```bash
location ~ ^/(?:index)\.php(?:$|/)
```

```bash
location ~ ^\/(?:core\/img\/background.png|core\/img\/favicon.ico)(?:$|\/)
```

```bash
location ~ ^/(?:index|core/ajax/update|ocs/v[12]|status|updater/.+|oc[ms]-provider/.+)\.php(?:$|/)
```
