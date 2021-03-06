package collaboRhythm.shared.model.healthRecord.document.healthActionPlan
{
	import collaboRhythm.shared.model.healthRecord.CodedValue;
	import collaboRhythm.shared.model.healthRecord.ValueAndUnit;

	[Bindable]
	public class DevicePlan
	{
		private var _name:CodedValue;
		private var _type:CodedValue;
		private var _value:ValueAndUnit;
		private var _site:CodedValue;
		private var _instructions:String;

		public function DevicePlan()
		{
		}

		public function get name():CodedValue
		{
			return _name;
		}

		public function set name(value:CodedValue):void
		{
			_name = value;
		}

		public function get type():CodedValue
		{
			return _type;
		}

		public function set type(value:CodedValue):void
		{
			_type = value;
		}

		public function get value():ValueAndUnit
		{
			return _value;
		}

		public function set value(value:ValueAndUnit):void
		{
			_value = value;
		}

		public function get site():CodedValue
		{
			return _site;
		}

		public function set site(value:CodedValue):void
		{
			_site = value;
		}

		public function get instructions():String
		{
			return _instructions;
		}

		public function set instructions(value:String):void
		{
			_instructions = value;
		}
	}
}
