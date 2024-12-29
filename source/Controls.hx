package;

import ChangeKeybinds.KeybindState;
import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
#if mobile
import mobile.flixel.FlxButton;
import mobile.flixel.FlxHitbox;
import mobile.flixel.FlxVirtualPad;
#end

#if (haxe >= "4.0.0")
enum abstract Action(String) to String from String
{
    var UP = "up";
    var LEFT = "left";
    var RIGHT = "right";
    var DOWN = "down";
    var UP_P = "up-press";
    var LEFT_P = "left-press";
    var RIGHT_P = "right-press";
    var DOWN_P = "down-press";
    var UP_R = "up-release";
    var LEFT_R = "left-release";
    var RIGHT_R = "right-release";
    var DOWN_R = "down-release";
    var ACCEPT = "accept";
    var BACK = "back";
    var PAUSE = "pause";
    var RESET = "reset";
    var CHEAT = "cheat";
}
#else
enum abstract Action(String) to String from String
{
    var UP = "up";
    var LEFT = "left";
    var RIGHT = "right";
    var DOWN = "down";
    var UP_P = "up-press";
    var LEFT_P = "left-press";
    var RIGHT_P = "right-press";
    var DOWN_P = "down-press";
    var UP_R = "up-release";
    var LEFT_R = "left-release";
    var RIGHT_R = "right-release";
    var DOWN_R = "down-release";
    var ACCEPT = "accept";
    var BACK = "back";
    var PAUSE = "pause";
    var RESET = "reset";
    var CHEAT = "cheat";
}
#end

enum Device
{
    Keys;
    Gamepad(id:Int);
}

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user perceives as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Control
{
    UP;
    LEFT;
    RIGHT;
    DOWN;
    RESET;
    ACCEPT;
    BACK;
    PAUSE;
    CHEAT;
}

enum KeyboardScheme
{
    Solo;
    Duo(first:Bool);
    None;
    Custom;
    Askl;
    ZxCommaDot;
}

/**
 * A list of actions that a player would invoke via some input device.
 * Uses FlxActions to funnel various inputs to a single action.
 */
class Controls extends FlxActionSet
{
    var _up = new FlxActionDigital(Action.UP);
    var _left = new FlxActionDigital(Action.LEFT);
    var _right = new FlxActionDigital(Action.RIGHT);
    var _down = new FlxActionDigital(Action.DOWN);
    var _upP = new FlxActionDigital(Action.UP_P);
    var _leftP = new FlxActionDigital(Action.LEFT_P);
    var _rightP = new FlxActionDigital(Action.RIGHT_P);
    var _downP = new FlxActionDigital(Action.DOWN_P);
    var _upR = new FlxActionDigital(Action.UP_R);
    var _leftR = new FlxActionDigital(Action.LEFT_R);
    var _rightR = new FlxActionDigital(Action.RIGHT_R);
    var _downR = new FlxActionDigital(Action.DOWN_R);
    var _accept = new FlxActionDigital(Action.ACCEPT);
    var _back = new FlxActionDigital(Action.BACK);
    var _pause = new FlxActionDigital(Action.PAUSE);
    var _reset = new FlxActionDigital(Action.RESET);
    var _cheat = new FlxActionDigital(Action.CHEAT);

    #if (haxe >= "4.0.0")
    var byName:Map<String, FlxActionDigital> = [];
    #else
    var byName:Map<String, FlxActionDigital> = new Map<String, FlxActionDigital>();
    #end

    public var gamepadsAdded:Array<Int> = [];
    public var keyboardScheme = KeyboardScheme.None;

    public var UP(get, never):Bool;

    inline function get_UP()
        return _up.check();

    public var LEFT(get, never):Bool;

    inline function get_LEFT()
        return _left.check();

    public var RIGHT(get, never):Bool;

    inline function get_RIGHT()
        return _right.check();

    public var DOWN(get, never):Bool;

    inline function get_DOWN()
        return _down.check();

    public var UP_P(get, never):Bool;

    inline function get_UP_P()
        return _upP.check();

    public var LEFT_P(get, never):Bool;

    inline function get_LEFT_P()
        return _leftP.check();

    public var RIGHT_P(get, never):Bool;

    inline function get_RIGHT_P()
        return _rightP.check();

    public var DOWN_P(get, never):Bool;

    inline function get_DOWN_P()
        return _downP.check();

    public var UP_R(get, never):Bool;

    inline function get_UP_R()
        return _upR.check();

    public var LEFT_R(get, never):Bool;

    inline function get_LEFT_R()
        return _leftR.check();

    public var RIGHT_R(get, never):Bool;

    inline function get_RIGHT_R()
        return _rightR.check();

    public var DOWN_R(get, never):Bool;

    inline function get_DOWN_R()
        return _downR.check();

    public var ACCEPT(get, never):Bool;

    inline function get_ACCEPT()
        return _accept.check();

    public var BACK(get, never):Bool;

    inline function get_BACK()
        return _back.check();

    public var PAUSE(get, never):Bool;

    inline function get_PAUSE()
        return _pause.check();

    public var RESET(get, never):Bool;

    inline function get_RESET()
        return _reset.check();

    public var CHEAT(get, never):Bool;

    inline function get_CHEAT()
        return _cheat.check();

    #if (haxe >= "4.0.0")
    public function new(name, scheme = None)
    {
        super(name);

        add(_up);
        add(_left);
        add(_right);
        add(_down);
        add(_upP);
        add(_leftP);
        add(_rightP);
        add(_downP);
        add(_upR);
        add(_leftR);
        add(_rightR);
        add(_downR);
        add(_accept);
        add(_back);
        add(_pause);
        add(_reset);
        add(_cheat);

        for (action in digitalActions)
            byName[action.name] = action;

        setKeyboardScheme(scheme, false);
    }
    #else
    public function new(name, scheme:KeyboardScheme = null)
    {
        super(name);

        add(_up);
        add(_left);
        add(_right);
        add(_down);
        add(_upP);
        add(_leftP);
        add(_rightP);
        add(_downP);
        add(_upR);
        add(_leftR);
        add(_rightR);
        add(_downR);
        add(_accept);
        add(_back);
        add(_pause);
        add(_reset);
        add(_cheat);

        for (action in digitalActions)
            byName[action.name] = action;
            
        if (scheme == null)
            scheme = None;
        setKeyboardScheme(scheme, false);
    }
    #end

    #if mobile
    public var trackedInputsUI:Array<FlxActionInput> = [];
    public var trackedInputsNOTES:Array<FlxActionInput> = [];

    public function addButtonNOTES(action:FlxActionDigital, button:FlxButton, state:FlxInputState)
    {
        var input:FlxActionInputDigitalIFlxInput = new FlxActionInputDigitalIFlxInput(button, state);
        trackedInputsNOTES.push(input);
        action.add(input);
    }

    public function addButtonUI(action:FlxActionDigital, button:FlxButton, state:FlxInputState)
    {
        var input:FlxActionInputDigitalIFlxInput = new FlxActionInputDigitalIFlxInput(button, state);
        trackedInputsUI.push(input);
        action.add(input);
    }

    public function setHitBox(Hitbox:FlxHitbox)
    {
        inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, Hitbox.buttonUp, state));
        inline forEachBound(Control.DOWN, (action, state) -> addButtonNOTES(action, Hitbox.buttonDown, state));
        inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, Hitbox.buttonLeft, state));
        inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, Hitbox.buttonRight, state));
    }

    public function setVirtualPadUI(VirtualPad:FlxVirtualPad, DPad:FlxDPadMode, Action:FlxActionMode)
    {
        switch (DPad)
        {
            case UP_DOWN:
                inline forEachBound(Control.UP, (action, state) -> addButtonUI(action, VirtualPad.buttonUp, state));
                inline forEachBound(Control.DOWN, (action, state) -> addButtonUI(action, VirtualPad.buttonDown, state));
            case LEFT_RIGHT:
                inline forEachBound(Control.LEFT, (action, state) -> addButtonUI(action, VirtualPad.buttonLeft, state));
                inline forEachBound(Control.RIGHT, (action, state) -> addButtonUI(action, VirtualPad.buttonRight, state));
            case UP_LEFT_RIGHT:
                inline forEachBound(Control.UP, (action, state) -> addButtonUI(action, VirtualPad.buttonUp, state));
                inline forEachBound(Control.LEFT, (action, state) -> addButtonUI(action, VirtualPad.buttonLeft, state));
                inline forEachBound(Control.RIGHT, (action, state) -> addButtonUI(action, VirtualPad.buttonRight, state));
            case LEFT_FULL | RIGHT_FULL:
                inline forEachBound(Control.UP, (action, state) -> addButtonUI(action, VirtualPad.buttonUp, state));
                inline forEachBound(Control.DOWN, (action, state) -> addButtonUI(action, VirtualPad.buttonDown, state));
                inline forEachBound(Control.LEFT, (action, state) -> addButtonUI(action, VirtualPad.buttonLeft, state));
                inline forEachBound(Control.RIGHT, (action, state) -> addButtonUI(action, VirtualPad.buttonRight, state));
            case BOTH_FULL:
                inline forEachBound(Control.UP, (action, state) -> addButtonUI(action, VirtualPad.buttonUp, state));
                inline forEachBound(Control.DOWN, (action, state) -> addButtonUI(action, VirtualPad.buttonDown, state));
                inline forEachBound(Control.LEFT, (action, state) -> addButtonUI(action, VirtualPad.buttonLeft, state));
                inline forEachBound(Control.RIGHT, (action, state) -> addButtonUI(action, VirtualPad.buttonRight, state));
                inline forEachBound(Control.UP, (action, state) -> addButtonUI(action, VirtualPad.buttonUp2, state));
                inline forEachBound(Control.DOWN, (action, state) -> addButtonUI(action, VirtualPad.buttonDown2, state));
                inline forEachBound(Control.LEFT, (action, state) -> addButtonUI(action, VirtualPad.buttonLeft2, state));
                inline forEachBound(Control.RIGHT, (action, state) -> addButtonUI(action, VirtualPad.buttonRight2, state));
            case NONE: // do nothing
        }

        switch (Action)
        {
            case A:
                inline forEachBound(Control.ACCEPT, (action, state) -> addButtonUI(action, VirtualPad.buttonA, state));
            case B:
                inline forEachBound(Control.BACK, (action, state) -> addButtonUI(action, VirtualPad.buttonB, state));
            case A_B | A_B_C | A_B_E | A_B_X_Y | A_B_C_X_Y | A_B_C_X_Y_Z | A_B_C_D_V_X_Y_Z:
                inline forEachBound(Control.ACCEPT, (action, state) -> addButtonUI(action, VirtualPad.buttonA, state));
                inline forEachBound(Control.BACK, (action, state) -> addButtonUI(action, VirtualPad.buttonB, state));
            case NONE: // do nothing
        }
    }

    public function setVirtualPadNOTES(VirtualPad:FlxVirtualPad, DPad:FlxDPadMode, Action:FlxActionMode)
    {
        switch (DPad)
        {
            case UP_DOWN:
                inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, VirtualPad.buttonUp, state));
                inline forEachBound(Control.DOWN, (action, state) -> addButtonNOTES(action, VirtualPad.buttonDown, state));
            case LEFT_RIGHT:
                inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonLeft, state));
                inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonRight, state));
            case UP_LEFT_RIGHT:
                inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, VirtualPad.buttonUp, state));
                inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonLeft, state));
                inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonRight, state));
            case LEFT_FULL | RIGHT_FULL:
                inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, VirtualPad.buttonUp, state));
                inline forEachBound(Control.DOWN, (action, state) -> addButtonNOTES(action, VirtualPad.buttonDown, state));
                inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonLeft, state));
                inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonRight, state));
            case BOTH_FULL:
                inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, VirtualPad.buttonUp, state));
                inline forEachBound(Control.DOWN, (action, state) -> addButtonNOTES(action, VirtualPad.buttonDown, state));
                inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonLeft, state));
                inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonRight, state));
                inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, VirtualPad.buttonUp2, state));
                inline forEachBound(Control.DOWN, (action, state) -> addButtonNOTES(action, VirtualPad.buttonDown2, state));
                inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonLeft2, state));
                inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonRight2, state));
            case NONE: // do nothing
        }

        switch (Action)
        {
            case A:
                inline forEachBound(Control.ACCEPT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonA, state));
            case B:
                inline forEachBound(Control.BACK, (action, state) -> addButtonNOTES(action, VirtualPad.buttonB, state));
            case A_B | A_B_C | A_B_E | A_B_X_Y | A_B_C_X_Y | A_B_C_X_Y_Z | A_B_C_D_V_X_Y_Z:
                inline forEachBound(Control.ACCEPT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonA, state));
                inline forEachBound(Control.BACK, (action, state) -> addButtonNOTES(action, VirtualPad.buttonB, state));
            case NONE: // do nothing
        }
    }

    public function removeVirtualControlsInput(Tinputs:Array<FlxActionInput>)
    {
        for (action in this.digitalActions)
        {
            var i = action.inputs.length;
            while (i-- > 0)
            {
                var x = Tinputs.length;
                while (x-- > 0)
                {
                    if (Tinputs[x] == action.inputs[i])
                        action.remove(action.inputs[i]);
                }
            }
        }
    }
    #end

    override function update()
    {
        super.update();
    }

    // inline
    public function checkByName(name:Action):Bool
    {
        #if debug
        if (!byName.exists(name))
            throw 'Invalid name: $name';
        #end
        return byName[name].check();
    }

    public function getDialogueName(action:FlxActionDigital):String
    {
        var input = action.inputs[0];
        return switch input.device
        {
            case KEYBOARD: return '[${(input.inputID : FlxKey)}]';
            case GAMEPAD: return '(${(input.inputID : FlxGamepadInputID)})';
            case device: throw 'unhandled device: $device';
        }
    }

    public function getDialogueNameFromToken(token:String):String
    {
        return getDialogueName(getActionFromControl(Control.createByName(token.toUpperCase())));
    }

    function getActionFromControl(control:Control):FlxActionDigital
    {
        return switch (control)
        {
            case UP: _up;
            case DOWN: _down;
            case LEFT: _left;
            case RIGHT: _right;
            case ACCEPT: _accept;
            case BACK: _back;
            case PAUSE: _pause;
            case RESET: _reset;
            case CHEAT: _cheat;
        }
    }

    static function init():Void
    {
        var actions = new FlxActionManager();
        FlxG.inputs.add(actions);
    }

    /**
     * Calls a function passing each action bound by the specified control
     * @param control
     * @param func
     * @return ->Void)
     */
    function forEachBound(control:Control, func:FlxActionDigital->FlxInputState->Void)
    {
        switch (control)
        {
            case UP:
                func(_up, PRESSED);
                func(_upP, JUST_PRESSED);
                func(_upR, JUST_RELEASED);
            case LEFT:
                func(_left, PRESSED);
                func(_leftP, JUST_PRESSED);
                func(_leftR, JUST_RELEASED);
            case RIGHT:
                func(_right, PRESSED);
                func(_rightP, JUST_PRESSED);
                func(_rightR, JUST_RELEASED);
            case DOWN:
                func(_down, PRESSED);
                func(_downP, JUST_PRESSED);
                func(_downR, JUST_RELEASED);
