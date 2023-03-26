import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class DoubanMovie extends StatefulWidget {
  const DoubanMovie({super.key});

  @override
  State<StatefulWidget> createState() => _DoubanMovie();
}

class _DoubanMovie extends State<DoubanMovie> {
  final List<DoubanMovieTitle> _list = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _loading = true;
    var url = "https://movie.douban.com/chart";
    Response response = await Dio().get(url);
    dom.Document document = parser.parse(response.data);
    List<dom.Element> elementsByClassName =
        document.getElementsByClassName('item');
    List<DoubanMovieTitle> list = [];
    for (dom.Element element in elementsByClassName) {
      String title = element
          .getElementsByClassName('pl2')[0]
          .children[0]
          .text
          .replaceAll('\n', '')
          .replaceAll('  ', '')
          .replaceFirst('/', ' /')
          .trim();
      while (title.contains('  ')) {
        title.replaceAll('  ', ' ').trim();
      }
      String subtitle = element.getElementsByClassName('pl')[0].text.split('/')[0].trim();
      DoubanMovieTitle alduinTitle =
          DoubanMovieTitle(title: title, subtitle: subtitle);
      list.add(alduinTitle);
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
              subtitle: Row(
                children: <Widget>[
                  const Icon(Icons.local_fire_department_outlined),
                  const SizedBox(width: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
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
          '豆瓣电影排行榜',
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

class DoubanMovieTitle {
  final String title;
  final String subtitle;

  DoubanMovieTitle({
    required this.title,
    required this.subtitle,
  });
}
