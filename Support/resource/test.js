var classmapping = {
    '.': 'pass',
    'F': 'fail',
    'E': 'error',
    's': 'skip'
};
var tests_done_separator = "======================================================================";
var traceback_separator = "----------------------------------------------------------------------";

function colorize() {
    var node = $('pre')
    var html = node.text();
    var bits = html.split(tests_done_separator);
    
    bits[0] = bits[0].replace(/[.FEs](?=[.FEs$\n])/g, function(match){
        var value = classmapping[match];
        return '<span class="test-'+value+'">'+match+'</span>'
    });
    
    if (bits.length > 1) {
        stop();
        var tracebacks = dress_up_tracebacks(bits.slice(1)).join('</li><li>');
        html = bits[0] + "<ul><li>" + tracebacks + "</li></ul>";
    } else {
        html = bits.join(tests_done_separator);
    }
    
    html = html.replace(/Ran \d+ test.*$/m, '</li></ul><div id="summary">$&</div>');
    html = html.replace(new RegExp(traceback_separator, 'g'), '<hr />')
    
    node.html(html);
}

function stop() {
    clearInterval(id);
}

function dress_up_tracebacks(tracebacks) {
    for (var i in tracebacks) {
        var traceback = tracebacks[i];
        
        traceback = traceback.replace(/(ERROR|FAIL): (test\w+) \(([^)]+)\)/, function(match, type, test, classname){
            return '<h2>'+test+'</h2><h3>'+classname+'</h3>';
        });
        
        tracebacks[i] = traceback;
    }
    return tracebacks;
}

var id = setInterval(colorize, 100);
