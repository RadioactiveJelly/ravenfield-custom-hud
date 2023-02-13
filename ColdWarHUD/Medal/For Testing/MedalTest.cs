using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MedalTest : MonoBehaviour
{

    [SerializeField] private Animator m_animator;

    private float _timer = 5.0f;
    private bool _showing = false;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.T))
        {
            _timer = 5.0f;
            _showing = true;
        }
    }
}
