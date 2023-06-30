import 'package:flutter/material.dart';
import '../tool/profile.dart';

class BlocklistSetting extends StatefulWidget {
  const BlocklistSetting({super.key});

  @override
  State<BlocklistSetting> createState() => _BlocklistSettingState();
}

class _BlocklistSettingState extends State<BlocklistSetting> {
  bool? block;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    block = UserProfiles.blocklist;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: block ?? UserProfiles.blocklist,
      // activeColor: Theme.of(context).primaryColor,
      // inactiveThumbColor: Theme.of(context).primaryColorDark,
      onChanged: _onchange,
      title: const Text('屏蔽功能(试验性)'),
      subtitle: const Text('自动隐藏黑名单中的用户相关内容'),
    );
  }

  void _onchange(bool value) {
    setState(() {
      block = value;
    });
    UserProfiles.setBlocklist(value);
  }
}

class BlocklistEdit extends StatelessWidget {
  const BlocklistEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text('黑名单'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigator.pushNamed(context, '/blocklist');
        });
  }
}
