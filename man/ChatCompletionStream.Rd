% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chat.R
\name{ChatCompletionStream}
\alias{ChatCompletionStream}
\title{ChatCompletionStream R6 class}
\description{
ChatCompletionStream R6 class

ChatCompletionStream R6 class
}
\section{Super classes}{
\code{openaiapi::Utils} -> \code{\link[openaiapi:ChatCompletion]{openaiapi::ChatCompletion}} -> \code{ChatCompletionStream}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-ChatCompletionStream-new}{\code{ChatCompletionStream$new()}}
\item \href{#method-ChatCompletionStream-stream_async}{\code{ChatCompletionStream$stream_async()}}
\item \href{#method-ChatCompletionStream-do_tool_calls}{\code{ChatCompletionStream$do_tool_calls()}}
\item \href{#method-ChatCompletionStream-clone}{\code{ChatCompletionStream$clone()}}
}
}
\if{html}{\out{
<details><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="openaiapi" data-topic="ChatCompletion" data-id="content_text"><a href='../../openaiapi/html/ChatCompletion.html#method-ChatCompletion-content_text'><code>openaiapi::ChatCompletion$content_text()</code></a></span></li>
<li><span class="pkg-link" data-pkg="openaiapi" data-topic="ChatCompletion" data-id="delete"><a href='../../openaiapi/html/ChatCompletion.html#method-ChatCompletion-delete'><code>openaiapi::ChatCompletion$delete()</code></a></span></li>
<li><span class="pkg-link" data-pkg="openaiapi" data-topic="ChatCompletion" data-id="get"><a href='../../openaiapi/html/ChatCompletion.html#method-ChatCompletion-get'><code>openaiapi::ChatCompletion$get()</code></a></span></li>
<li><span class="pkg-link" data-pkg="openaiapi" data-topic="ChatCompletion" data-id="get_chat_messages"><a href='../../openaiapi/html/ChatCompletion.html#method-ChatCompletion-get_chat_messages'><code>openaiapi::ChatCompletion$get_chat_messages()</code></a></span></li>
<li><span class="pkg-link" data-pkg="openaiapi" data-topic="ChatCompletion" data-id="print"><a href='../../openaiapi/html/ChatCompletion.html#method-ChatCompletion-print'><code>openaiapi::ChatCompletion$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="openaiapi" data-topic="ChatCompletion" data-id="update"><a href='../../openaiapi/html/ChatCompletion.html#method-ChatCompletion-update'><code>openaiapi::ChatCompletion$update()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ChatCompletionStream-new"></a>}}
\if{latex}{\out{\hypertarget{method-ChatCompletionStream-new}{}}}
\subsection{Method \code{new()}}{
Initialize a ChatCompletionStream object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ChatCompletionStream$new(stream_reader)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{stream_reader}}{A StreamReader object.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ChatCompletionStream-stream_async"></a>}}
\if{latex}{\out{\hypertarget{method-ChatCompletionStream-stream_async}{}}}
\subsection{Method \code{stream_async()}}{
Get the chat completion object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ChatCompletionStream$stream_async(callback)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{callback}}{A function that is called on each event, taking the updated \code{choices} field as an argument.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ChatCompletionStream-do_tool_calls"></a>}}
\if{latex}{\out{\hypertarget{method-ChatCompletionStream-do_tool_calls}{}}}
\subsection{Method \code{do_tool_calls()}}{
Get the chat completion object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ChatCompletionStream$do_tool_calls(env = parent.env())}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{env}}{The environment to use for tool calls.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ChatCompletionStream-clone"></a>}}
\if{latex}{\out{\hypertarget{method-ChatCompletionStream-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ChatCompletionStream$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
