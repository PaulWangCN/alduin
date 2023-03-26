import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class Github extends StatefulWidget {
  const Github({super.key});

  @override
  State<Github> createState() => _Github();
}

class _Github extends State<Github> {

  final List<GithubTrendingTitle> _list = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _loading = true;
    var url = "https://github.com/trending";
    Response response = await Dio().get(url);
    dom.Document document = parser.parse(response.data);
    List<dom.Element> elementsByClassName =
    document.getElementsByClassName('Box-row');
    List<GithubTrendingTitle> list = [];
    for (dom.Element element in elementsByClassName) {
      dom.Element titleEle =
      element.getElementsByClassName('h3 lh-condensed')[0];
      String name = titleEle.text.trim();
      dom.Element? subtitleEle = titleEle.nextElementSibling;
      String prefix = name.split('/')[0].trim();
      String suffix = name.split('/')[1].trim();
      String title = "$prefix / $suffix";
      String subtitle = '';
      if (subtitleEle != null &&
          subtitleEle.className == 'col-9 color-fg-muted my-1 pr-4') {
        subtitle = subtitleEle.text.trim();
      }
      GithubTrendingTitle trending = GithubTrendingTitle(
        title: title,
        subtitle: subtitle,
      );
      list.add(trending);
    }
    setState(() {
      _list.clear();
      _list.addAll(list);
    });
    _loading = false;
  }

  Widget _childLayout() {
    if (_loading) {
      return const Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.blue,
          ),
        ),
      );
    } else {
      return Builder(builder: (context) {
        return ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            final int lineNo = index + 1;
            final String title = (_list)[index].title;
            final String subtitle = (_list)[index].subtitle;
            return ListTile(
              title: Text(
                '#$lineNo $title',
                style: const TextStyle(color: Colors.lightBlue),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(color: Colors.grey),
              ),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: title));
                const snackBar = SnackBar(
                  content: Text('标题已复制！'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'github最热',
          style: TextStyle(),
        ),
      ),
      body: _childLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: '刷新',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class GithubTrendingTitle {
  final String title;
  final String subtitle;

  GithubTrendingTitle({
    required this.title,
    required this.subtitle,
  });

}
