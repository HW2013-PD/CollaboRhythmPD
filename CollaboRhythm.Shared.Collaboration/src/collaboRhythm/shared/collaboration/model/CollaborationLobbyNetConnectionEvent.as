/**
 * Copyright 2011 John Moore, Scott Gilroy
 *
 * This file is part of CollaboRhythm.
 *
 * CollaboRhythm is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later
 * version.
 *
 * CollaboRhythm is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with CollaboRhythm.  If not, see
 * <http://www.gnu.org/licenses/>.
 */
package collaboRhythm.shared.collaboration.model
{

	import flash.events.Event;

	public class CollaborationLobbyNetConnectionEvent extends Event
	{
		public static const ERROR:String = "Error";
		public static const SYNCHRONIZE:String = "Synchronize";
		public static const END_COLLABORATION:String = "endCollaboration";

		private var _accountId:String;

		public function CollaborationLobbyNetConnectionEvent(type:String, accountId:String = null)
		{
			super(type);
			_accountId = accountId;
		}

		public function get accountId():String
		{
			return _accountId;
		}
	}
}
