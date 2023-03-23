import 'package:alduin/alduin_title.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  final List<AlduinTitle> _list = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _loading = true;
    var url = "https://www.zhihu.com/billboard";
    Response response = await Dio().get(url);
    dom.Document document = parser.parse(response.data);
    List<dom.Element> elementsByClassName =
        document.getElementsByClassName('HotList-item');
    List<AlduinTitle> list = [];
    for (dom.Element element in elementsByClassName) {
      String title =
          element.getElementsByClassName('HotList-itemTitle')[0].text.trim();
      String subtitle =
          element.getElementsByClassName('HotList-itemMetrics')[0].text.trim();
      AlduinTitle alduinTitle = AlduinTitle(title: title, subtitle: subtitle);
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
                style: const TextStyle(color: Colors.blue),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _childLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: '刷新',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
