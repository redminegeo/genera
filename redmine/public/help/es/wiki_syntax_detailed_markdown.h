<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>RedmineWikiFormatting (Markdown)</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="../wiki_syntax_detailed.css" />
</head>

<body>
<h1><a name="1" class="wiki-page"></a>Wiki formatting (Markdown)</h1>

    <h2><a name="2" class="wiki-page"></a>Links</h2>

        <h3><a name="3" class="wiki-page"></a>Redmine links</h3>

        <p>Redmine allows hyperlinking between resources (issues, changesets, wiki pages...) from anywhere wiki formatting is used.</p>
        <ul>
            <li>Link to an issue: <strong>#124</strong> (displays <del><a href="#" class="issue" title="bulk edit doesn't change the category or fixed version properties (Closed)">#124</a></del>, link is striked-through if the issue is closed)</li>
            <li>Link to an issue note: <strong>#124-6</strong>, or <strong>#124#note-6</strong></li>
        </ul>

        <p>Wiki links:</p>

        <ul>
            <li><strong>[[Guide]]</strong> displays a link to the page named 'Guide': <a href="#" class="wiki-page">Guide</a></li>
            <li><strong>[[Guide#further-reading]]</strong> takes you to the anchor "further-reading". Headings get automatically assigned anchors so that you can refer to them: <a href="#" class="wiki-page">Guide</a></li>
            <li><strong>[[Guide|User manual]]</strong> displays a link to the same page but with a different text: <a href="#" class="wiki-page">User manual</a></li>
        </ul>

        <p>You can also link to pages of an other project wiki:</p>

        <ul>
            <li><strong>[[sandbox:some page]]</strong> displays a link to the page named 'Some page' of the Sandbox wiki</li>
            <li><strong>[[sandbox:]]</strong> displays a link to the Sandbox wiki main page</li>
        </ul>

        <p>Wiki links are displayed in red if the page doesn't exist yet, eg: <a href="#" class="wiki-page new">Nonexistent page</a>.</p>

        <p>Links to other resources:</p>

        <ul>
            <li>Documents:
                <ul>
                    <li><strong>document#17</strong> (link to document with id 17)</li>
                    <li><strong>document:Greetings</strong> (link to the document with title "Greetings")</li>
                    <li><strong>document:"Some document"</strong> (double quotes can be used when document title contains spaces)</li>
                    <li><strong>sandbox:document:"Some document"</strong> (link to a document with title "Some document" in other project "sandbox")</li>
                </ul>
            </li>
        </ul>

        <ul>
            <li>Versions:
                <ul>
                    <li><strong>version#3</strong> (link to version with id 3)</li>
                    <li><strong>version:1.0.0</strong> (link to version named "1.0.0")</li>
                    <li><strong>version:"1.0 beta 2"</strong></li>
                    <li><strong>sandbox:version:1.0.0</strong> (link to version "1.0.0" in the project "sandbox")</li>
                </ul>
            </li>
        </ul>

        <ul>
            <li>Attachments:
                <ul>
                    <li><strong>attachment:file.zip</strong> (link to the attachment of the current object named file.zip)</li>
                    <li>For now, attachments of the current object can be referenced only (if you're on an issue, it's possible to reference attachments of this issue only)</li>
                </ul>
            </li>
        </ul>

        <ul>
            <li>Changesets:
                <ul>
                    <li><strong>r758</strong>                       (link to a changeset)</li>
                    <li><strong>commit:c6f4d0fd</strong>            (link to a changeset with a non-numeric hash)</li>
                    <li><strong>svn1|r758</strong>                  (link to a changeset of a specific repository, for projects with multiple repositories)</li>
                    <li><strong>commit:hg|c6f4d0fd</strong>         (link to a changeset with a non-numeric hash of a specific repository)</li>
                    <li><strong>sandbox:r758</strong>               (link to a changeset of another project)</li>
                    <li><strong>sandbox:commit:c6f4d0fd</strong>    (link to a changeset with a non-numeric hash of another project)</li>
                </ul>
            </li>
        </ul>

        <ul>
             <li>Repository files:
                <ul>
                    <li><strong>source:some/file</strong>           (link to the file located at /some/file in the project's repository)</li>
                    <li><strong>source:some/file@52</strong>        (link to the file's revision 52)</li>
                    <li><strong>source:some/file#L120</strong>      (link to line 120 of the file)</li>
                    <li><strong>source:some/file@52#L120</strong>   (link to line 120 of the file's revision 52)</li>
                    <li><strong>source:"some file@52#L120"</strong> (use double quotes when the URL contains spaces</li>
                    <li><strong>export:some/file</strong>           (force the download of the file)</li>
                    <li><strong>source:svn1|some/file</strong>      (link to a file of a specific repository, for projects with multiple repositories)</li>
                    <li><strong>sandbox:source:some/file</strong>   (link to the file located at /some/file in the repository of the project "sandbox")</li>
                    <li><strong>sandbox:export:some/file</strong>   (force the download of the file)</li>
                </ul>
            </li>
        </ul>

        <ul>
            <li>Forums:
                <ul>
                    <li><strong>forum#1</strong> (link to forum with id 1</li>
                    <li><strong>forum:Support</strong> (link to forum named Support)</li>
                    <li><strong>forum:"Technical Support"</strong> (use double quotes if forum name contains spaces)</li>
                </ul>
            </li>
        </ul>

        <ul>
            <li>Forum messages:
                <ul>
                    <li><strong>message#1218</strong> (link to message with id 1218)</li>
                </ul>
            </li>
        </ul>

        <ul>
            <li>Projects:
                <ul>
                    <li><strong>project#3</strong> (link to project with id 3)</li>
                    <li><strong>project:some-project</strong> (link to project with name or slug of "some-project")</li>
                    <li><strong>project:"Some Project"</strong> (use double quotes for project name containing spaces)</li>
                </ul>
             </li>
        </ul>

        <ul>
            <li>News:
                <ul>
                    <li><strong>news#2</strong> (link to news item with id 2)</li>
                    <li><strong>news:Greetings</strong> (link to news item named "Greetings")</li>
                    <li><strong>news:"First Release"</strong> (use double quotes if news item name contains spaces)</li>
                </ul>
            </li>
        </ul>

        <ul>
            <li>Users:
                <ul>
                    <li><strong>user#2</strong> (link to user with id 2)</li>
                    <li><strong>user:jsmith</strong> (Link to user with login jsmith)</li>
                    <li><strong>@jsmith</strong> (Link to user with login jsmith)</li>
                </ul>
            </li>
        </ul>

        <p>Escaping:</p>

        <ul>
            <li>You can prevent Redmine links from being parsed by preceding them with an exclamation mark: !</li>
        </ul>


        <h3><a name="4" class="wiki-page"></a>External links</h3>

        <p>URLs (starting with: www, http, https, ftp, ftps, sftp and sftps) and email addresses are automatically turned into clickable links:</p>

<pre>
http://www.redmine.org, someone@foo.bar
</pre>

        <p>displays: <a class="external" href="http://www.redmine.org">http://www.redmine.org</a>, <a href="mailto:someone@foo.bar" class="email">someone@foo.bar</a></p>

        <p>If you want to display a specific text instead of the URL, you can use the standard markdown syntax:</p>

<pre>
[Redmine web site](http://www.redmine.org)
</pre>

        <p>displays: <a href="http://www.redmine.org" class="external">Redmine web site</a></p>


    <h2><a name="5" class="wiki-page"></a>Text formatting</h2>


    <p>For things such as headlines, bold, tables, lists, Redmine supports Markdown syntax.  See <a class="external" href="http://daringfireball.net/projects/markdown/syntax">http://daringfireball.net/projects/markdown/syntax</a> for information on using any of these features.  A few samples are included below, but the engine is capable of much more of that.</p>

        <h3><a name="6" class="wiki-page"></a>Font style</h3>

<pre>
* **bold**
* *Italic*
* ***bold italic***
* ~~strike-through~~
</pre>

        <p>Display:</p>

        <ul>
            <li><strong>bold</strong></li>
            <li><em>italic</em></li>
            <li><em><strong>bold italic</strong></em></li>
            <li><del>strike-through</del></li>
        </ul>

        <h3><a name="7" class="wiki-page"></a>Inline images</h3>

        <ul>
            <li><strong>![](image_url)</strong> displays an image located at image_url (markdown syntax)</li>
            <li>If you have an image attached to your wiki page, it can be displayed inline using its filename: <strong>![](attached_image)</strong></li>
        </ul>

        <h3><a name="8" class="wiki-page"></a>Headings</h3>

<pre>
# Heading
## Subheading
### Subsubheading
</pre>

        <p>Redmine assigns an anchor to each of those headings thus you can link to them with "#Heading", "#Subheading" and so forth.</p>


        <h3><a name="10" class="wiki-page"></a>Blockquotes</h3>

        <p>Start the paragraph with <strong>&gt;</strong></p>

<pre>
&gt; Rails is a full-stack framework for developing database-backed web applications according to the Model-View-Control pattern.
To go live, all you need to add is a database and a web server.
</pre>

        <p>Display:</p>

        <blockquote>
                <p>Rails is a full-stack framework for developing database-backed web applications according to the Model-View-Control pattern.<br />To go live, all you need to add is a database and a web server.</p>
        </blockquote>


        <h3><a name="11" class="wiki-page"></a>Table of content</h3>

<pre>
{{toc}} =&gt; left aligned toc
{{&gt;toc}} =&gt; right aligned toc
</pre>

        <h3><a name="14" class="wiki-page"></a>Horizontal Rule</h3>

<pre>
---
</pre>

    <h2><a name="12" class="wiki-page"></a>Macros</h2>

    <p>Redmine has the following builtin macros:</p>

    <p>
    <dl>
      <dt><code>hello_world</code></dt>
      <dd><p>Sample macro.</p></dd>

      <dt><code>macro_list</code></dt>
      <dd><p>Displays a list of all available macros, including description if available.</p></dd>

      <dt><code>child_pages</code></dt>
      <dd><p>Displays a list of child pages. With no argument, it displays the child pages of the current wiki page. Examples:</p>
      <pre><code>{{child_pages}} -- can be used from a wiki page only
{{child_pages(depth=2)}} -- display 2 levels nesting only</code></pre></dd>

      <dt><code>include</code></dt>
      <dd><p>Include a wiki page. Example:</p>
      <pre><code>{{include(Foo)}}</code></pre>
      <p>or to include a page of a specific project wiki:</p>
      <pre><code>{{include(projectname:Foo)}}</code></pre></dd>

      <dt><code>collapse</code></dt>
      <dd><p>Inserts of collapsed block of text. Example:</p>
      <pre><code>{{collapse(View details...)
This is a block of text that is collapsed by default.
It can be expanded by clicking a link.
}}</code></pre></dd>

      <dt><code>thumbnail</code></dt>
      <dd><p>Displays a clickable thumbnail of an attached image. Examples:</p>
      <pre>{{thumbnail(image.png)}}
{{thumbnail(image.png, size=300, title=Thumbnail)}}</pre></dd>
    </dl>
    </p>

    <h2><a name="13" class="wiki-page"></a>Code highlighting</h2>

    <p>Default code highlightment relies on <a href="http://coderay.rubychan.de/" class="external">CodeRay</a>, a fast syntax highlighting library written completely in Ruby. It currently supports c, clojure, cpp (c++, cplusplus), css, delphi (pascal), diff (patch), erb (eruby, rhtml), go, groovy, haml, html (xhtml), java, javascript (ecmascript, ecma_script, java_script, js), json, lua, php, python, ruby (irb), sass, sql, taskpaper, text (plain, plaintext), xml and yaml (yml) languages, where the names inside parentheses are aliases.</p>

    <p>You can highlight code at any place that supports wiki formatting using this syntax (note that the language name or alias is case-insensitive):</p>

<pre>
~~~ ruby
  Place your code here.
~~~
</pre>

    <p>Example:</p>

<pre><code class="ruby syntaxhl"><span class="CodeRay"><span class="comment"># The Greeter class</span>
<span class="keyword">class</span> <span class="class">Greeter</span>
  <span class="keyword">def</span> <span class="function">initialize</span>(name)
    <span class="instance-variable">@name</span> = name.capitalize
  <span class="keyword">end</span>

  <span class="keyword">def</span> <span class="function">salute</span>
    puts <span class="string"><span class="delimiter">"</span><span class="content">Hello </span><span class="inline"><span class="inline-delimiter">#{</span><span class="instance-variable">@name</span><span class="inline-delimiter">}</span></span><span class="content">!</span><span class="delimiter">"</span></span>
  <span class="keyword">end</span>
<span class="keyword">end</span></span></code>
</pre>
</body>
</html>

