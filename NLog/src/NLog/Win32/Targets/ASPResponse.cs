// 
// Copyright (c) 2004-2006 Jaroslaw Kowalski <jaak@jkowalski.net>
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
// 
// * Redistributions of source code must retain the above copyright notice, 
//   this list of conditions and the following disclaimer. 
// 
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution. 
// 
// * Neither the name of Jaroslaw Kowalski nor the names of its 
//   contributors may be used to endorse or promote products derived from this
//   software without specific prior written permission. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
// THE POSSIBILITY OF SUCH DAMAGE.
// 

#if !NETCF

using System;
using System.Runtime.InteropServices;

using NLog.Config;
using NLog.Targets;

namespace NLog.Win32.Targets
{
    /// <summary>
    /// Outputs logging messages through the ASP Response object.
    /// </summary>
    [Target("ASPResponse")]
    [SupportedRuntime(RuntimeOS.Win32)]
    public sealed class ASPResponseTarget: Target
    {
        private bool _addComments;

        /// <summary>
        /// Add &lt;!-- --&gt; comments around all written texts.
        /// </summary>
        public bool AddComments
        {
            get { return _addComments; }
            set { _addComments = value; }
        }
     
        /// <summary>
        /// Outputs the rendered logging event through the <c>OutputDebugString()</c> Win32 API.
        /// </summary>
        /// <param name="logEvent">The logging event.</param>
        protected internal override void Write(LogEventInfo logEvent)
        {
            ASPHelper.IResponse response = ASPHelper.GetResponseObject();
            if (response != null)
            {
                if (AddComments)
                {
                    response.Write("<!-- " + CompiledLayout.GetFormattedMessage(logEvent) + "-->");
                }
                else
                {
                    response.Write(CompiledLayout.GetFormattedMessage(logEvent));
                }
                Marshal.ReleaseComObject(response);
            }
        }
    }
}

#endif